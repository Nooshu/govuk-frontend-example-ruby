# frozen_string_literal: true

require "json"

module Govuk
  # Sentinel for missing options (distinct from JSON null).
  UNDEFINED = Object.new.freeze

  # Trusted HTML that must be emitted without escaping (Nunjucks SafeString).
  class Safe < String
  end

  # JSON number preserving original spelling (JavaScript / fixture parity).
  class Number < String
    def as_int
      Integer(self, 10)
    rescue ArgumentError
      nil
    end

    def as_float
      Float(self)
    end
  end

  # Ordered set of component options (Nunjucks object literal equivalent).
  class Params
    def initialize
      @keys = []
      @values = {}
    end

    def set(key, value)
      @keys << key unless @values.key?(key)
      @values[key] = value
      self
    end

    def get(key)
      return UNDEFINED unless @values.key?(key)

      @values[key]
    end

    def has?(key)
      @values.key?(key)
    end

    def keys
      @keys.dup
    end

    def length
      @keys.length
    end
    alias size length

    def each_key(&block)
      @keys.each(&block)
    end

    def each_pair
      return enum_for(:each_pair) unless block_given?

      @keys.each { |key| yield key, @values[key] }
    end

    def self.new_params(*pairs)
      raise ArgumentError, "new_params needs an even number of arguments" if pairs.length.odd?

      params = new
      pairs.each_slice(2) do |key, value|
        raise TypeError, "new_params key is not a string" unless key.is_a?(String)

        params.set(key, value)
      end
      params
    end

    def self.parse_json(data)
      text = data.is_a?(String) ? data : data.to_s.force_encoding("UTF-8")
      scan(text, 0)[0]
    end

    def self.params_from_mapping(data)
      return new if data.nil?
      return data if data.is_a?(Params)

      result = new
      data.each { |key, value| result.set(key, coerce(value)) }
      result
    end

    def self.coerce(value)
      case value
      when Hash
        params_from_mapping(value)
      when Array
        value.map { |item| coerce(item) }
      when Float
        if value.to_i == value
          Number.new(value.to_i.to_s)
        else
          text = format("%f", value).sub(/\.?0+\z/, "")
          Number.new(text.empty? ? "0" : text)
        end
      when Integer
        Number.new(value.to_s)
      else
        value
      end
    end

    def self.scan(text, idx)
      idx = skip_ws(text, idx)
      raise JSON::ParserError, "Expecting value" if idx >= text.length

      ch = text[idx]
      case ch
      when "{" then scan_object(text, idx)
      when "[" then scan_array(text, idx)
      when '"' then scan_string(text, idx)
      when "t"
        raise JSON::ParserError, "Expecting true" unless text[idx, 4] == "true"

        [true, idx + 4]
      when "f"
        raise JSON::ParserError, "Expecting false" unless text[idx, 5] == "false"

        [false, idx + 5]
      when "n"
        raise JSON::ParserError, "Expecting null" unless text[idx, 4] == "null"

        [nil, idx + 4]
      when "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        scan_number(text, idx)
      else
        raise JSON::ParserError, "Unexpected character #{ch.inspect}"
      end
    end

    def self.skip_ws(text, idx)
      idx += 1 while idx < text.length && " \t\r\n".include?(text[idx])
      idx
    end

    def self.scan_object(text, idx)
      idx += 1
      obj = new
      idx = skip_ws(text, idx)
      return [obj, idx + 1] if idx < text.length && text[idx] == "}"

      loop do
        idx = skip_ws(text, idx)
        raise JSON::ParserError, "Expecting property name" if idx >= text.length || text[idx] != '"'

        key, idx = scan_string(text, idx)
        idx = skip_ws(text, idx)
        raise JSON::ParserError, "Expecting ':'" if idx >= text.length || text[idx] != ":"

        idx += 1
        value, idx = scan(text, idx)
        obj.set(key, value)
        idx = skip_ws(text, idx)
        raise JSON::ParserError, "Expecting ',' or '}'" if idx >= text.length
        return [obj, idx + 1] if text[idx] == "}"
        raise JSON::ParserError, "Expecting ',' or '}'" if text[idx] != ","

        idx += 1
      end
    end

    def self.scan_array(text, idx)
      idx += 1
      items = []
      idx = skip_ws(text, idx)
      return [items, idx + 1] if idx < text.length && text[idx] == "]"

      loop do
        value, idx = scan(text, idx)
        items << value
        idx = skip_ws(text, idx)
        raise JSON::ParserError, "Expecting ',' or ']'" if idx >= text.length
        return [items, idx + 1] if text[idx] == "]"
        raise JSON::ParserError, "Expecting ',' or ']'" if text[idx] != ","

        idx += 1
      end
    end

    def self.scan_string(text, idx)
      i = idx + 1
      buf = +""
      while i < text.length
        ch = text[i]
        if ch == '"'
          return [buf, i + 1]
        elsif ch == "\\"
          i += 1
          raise JSON::ParserError, "Unterminated escape" if i >= text.length

          esc = text[i]
          case esc
          when '"', "\\", "/"
            buf << esc
          when "b" then buf << "\b"
          when "f" then buf << "\f"
          when "n" then buf << "\n"
          when "r" then buf << "\r"
          when "t" then buf << "\t"
          when "u"
            hex = text[i + 1, 4]
            raise JSON::ParserError, "Invalid unicode escape" unless hex&.match?(/\A[0-9a-fA-F]{4}\z/)

            buf << [hex.to_i(16)].pack("U")
            i += 4
          else
            raise JSON::ParserError, "Invalid escape"
          end
          i += 1
        else
          buf << ch
          i += 1
        end
      end
      raise JSON::ParserError, "Unterminated string"
    end

    def self.scan_number(text, idx)
      start = idx
      idx += 1 if text[idx] == "-"
      raise JSON::ParserError, "Invalid number" if idx >= text.length || !"0123456789".include?(text[idx])

      if text[idx] == "0"
        idx += 1
      else
        idx += 1 while idx < text.length && "0123456789".include?(text[idx])
      end
      if idx < text.length && text[idx] == "."
        idx += 1
        raise JSON::ParserError, "Invalid number" if idx >= text.length || !"0123456789".include?(text[idx])

        idx += 1 while idx < text.length && "0123456789".include?(text[idx])
      end
      if idx < text.length && "eE".include?(text[idx])
        idx += 1
        idx += 1 if idx < text.length && "+-".include?(text[idx])
        raise JSON::ParserError, "Invalid number" if idx >= text.length || !"0123456789".include?(text[idx])

        idx += 1 while idx < text.length && "0123456789".include?(text[idx])
      end
      [Number.new(text[start...idx]), idx]
    end
  end
end

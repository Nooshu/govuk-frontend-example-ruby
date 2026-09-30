# frozen_string_literal: true

module Govuk
  # Nunjucks-parity filters: escape, indent, length, and related helpers.
  module Nunjucks
    module_function

    ESCAPES = [
      ["&", "&amp;"],
      ['"', "&quot;"],
      ["'", "&#39;"],
      ["<", "&lt;"],
      [">", "&gt;"],
      ["\\", "&#92;"]
    ].freeze

    def escape(text)
      result = text.to_s
      ESCAPES.each { |old, new| result = result.gsub(old, new) }
      result
    end

    def get(value, *names)
      names.each do |name|
        return UNDEFINED unless value.is_a?(Params)

        value = value.get(name)
      end
      value
    end

    def items(value)
      value.is_a?(Array) ? value : []
    end

    def at(value, index)
      list = items(value)
      return UNDEFINED if index.negative? || index >= list.length

      list[index]
    end

    def truthy?(value)
      return false if value.nil? || undefined?(value)
      return value if [true, false].include?(value)
      return Float(value) != 0 if value.is_a?(Number)
      return !value.empty? if value.is_a?(String)

      true
    end

    def undefined?(value)
      value.equal?(UNDEFINED)
    end

    def str_value(value)
      return "" if value.nil? || undefined?(value)
      return value.to_s if value.is_a?(Safe)
      return format_number(value) if value.is_a?(Number)
      return value if value.is_a?(String)
      return value ? "true" : "false" if [true, false].include?(value)
      return value.map { |item| str_value(item) }.join(",") if value.is_a?(Array)

      "[object Object]"
    end

    def format_number(value)
      text = value.to_s
      begin
        return Integer(text, 10).to_s
      rescue ArgumentError
        # float path
      end
      begin
        f = Float(text)
        formatted = format("%.16f", f).sub(/\.?0+\z/, "")
        formatted.empty? ? "0" : formatted
      rescue ArgumentError
        text
      end
    end

    def out(value)
      return value.to_s if value.is_a?(Safe)

      escape(str_value(value))
    end

    def trim(text)
      text.to_s.strip
    end

    def indent(text, width, first)
      return "" if text == ""

      padding = " " * width
      lines = text.split("\n", -1)
      lines.each_with_index do |line, i|
        next if i.zero? && !first

        lines[i] = padding + line
      end
      lines.join("\n")
    end

    def default(value, fallback)
      undefined?(value) ? fallback : value
    end

    def default_truthy(value, fallback)
      truthy?(value) ? value : fallback
    end

    def length(value)
      return 0 if value.nil? || undefined?(value)
      return 0 if [true, false].include?(value)
      return value.length if value.is_a?(Array)
      return value.length if value.is_a?(Params)
      return value.to_s.length if value.is_a?(Safe)
      return value.length if value.is_a?(String)

      0
    end

    def loose_eq(left, right)
      left_nil = left.nil? || undefined?(left)
      right_nil = right.nil? || undefined?(right)
      return left_nil && right_nil if left_nil || right_nil

      left_bool = [true, false].include?(left)
      right_bool = [true, false].include?(right)
      return left == right if left_bool && right_bool
      return loose_eq(bool_to_number(left), right) if left_bool
      return loose_eq(left, bool_to_number(right)) if right_bool

      left_num = left.is_a?(Number)
      right_num = right.is_a?(Number)
      return numeric(left.to_s) == numeric(right.to_s) if left_num && right_num
      return same_number(left.to_s, str_value(right)) if left_num
      return same_number(str_value(left), right.to_s) if right_num

      str_value(left) == str_value(right)
    end

    def strict_eq(left, right)
      return undefined?(left) && undefined?(right) if undefined?(left) || undefined?(right)
      return left.nil? && right.nil? if left.nil? || right.nil?

      left_num = left.is_a?(Number)
      right_num = right.is_a?(Number)
      return false if left_num != right_num
      return numeric(left.to_s) == numeric(right.to_s) if left_num

      if [true, false].include?(left)
        return [true, false].include?(right) && left == right
      end
      if left.is_a?(String) && !left.is_a?(Number)
        return right.is_a?(String) && !right.is_a?(Number) && left == right
      end

      left == right
    end

    def contains?(needle, haystack)
      if haystack.is_a?(Safe)
        return haystack.to_s.include?(str_value(needle))
      end
      if haystack.is_a?(String) && !haystack.is_a?(Number)
        return haystack.include?(str_value(needle))
      end
      if haystack.is_a?(Array)
        return haystack.any? { |item| strict_eq(needle, item) }
      end
      return haystack.has?(str_value(needle)) if haystack.is_a?(Params)

      false
    end

    def concat_if(prefix, value)
      return "" unless truthy?(value)

      prefix + str_value(value)
    end

    def heading(level, fallback)
      truthy?(level) ? str_value(level) : fallback
    end

    def bool_to_number(value)
      Number.new(value ? "1" : "0")
    end

    def numeric(text)
      Float(text)
    rescue ArgumentError
      0.0
    end

    def same_number(left, right)
      trimmed = right.strip
      trimmed = "0" if trimmed == ""
      value = Float(trimmed)
      numeric(left) == value
    rescue ArgumentError
      false
    end
  end
end

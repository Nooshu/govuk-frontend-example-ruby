# frozen_string_literal: true

module Govuk
  module Attributes
    module_function

    def attributes(value)
      return value.to_s if value.is_a?(Safe)
      return value if value.is_a?(String)

      if value.is_a?(Params)
        value.keys.map { |name| attribute(name, value.get(name)) }.join
      else
        ""
      end
    end

    def attribute(name, item)
      value = item
      optional = false
      if item.is_a?(Params)
        value = item.get("value")
        flag = item.get("optional")
        optional = flag == true
      end

      empty = value.nil? || Nunjucks.undefined?(value)
      escaped = ""
      unless empty
        escaped = value.is_a?(Safe) ? value.to_s : Nunjucks.escape(Nunjucks.str_value(value))
      end

      if optional
        is_bool = [true, false].include?(value)
        return " #{Nunjucks.escape(name)}" if is_bool && value
        return "" if empty || (is_bool && !value)
      end
      " #{Nunjucks.escape(name)}=\"#{escaped}\""
    end

    def i18n_attributes(key, message, messages)
      if Nunjucks.truthy?(messages)
        return "" unless messages.is_a?(Params)

        return messages.keys.map do |rule|
          " data-i18n.#{key}.#{rule}=\"#{Nunjucks.escape(Nunjucks.str_value(messages.get(rule)))}\""
        end.join
      end
      if Nunjucks.truthy?(message)
        return " data-i18n.#{key}=\"#{Nunjucks.escape(Nunjucks.str_value(message))}\""
      end

      ""
    end

    def attribute_if(name, value)
      return "" unless Nunjucks.truthy?(value)

      " #{name}=\"#{Nunjucks.out(value)}\""
    end

    def classes_if(value)
      return "" unless Nunjucks.truthy?(value)

      " #{Nunjucks.out(value)}"
    end

    def flag_if(suffix, value)
      return "" unless Nunjucks.truthy?(value)

      suffix
    end

    def content(params, html_key, text_key)
      html = Nunjucks.get(params, html_key)
      return Nunjucks.str_value(html) if Nunjucks.truthy?(html)

      Nunjucks.out(Nunjucks.get(params, text_key))
    end

    def content_indent(params, html_key, text_key, width)
      html = Nunjucks.get(params, html_key)
      if Nunjucks.truthy?(html)
        return Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), width, false)
      end

      Nunjucks.out(Nunjucks.get(params, text_key))
    end
  end
end

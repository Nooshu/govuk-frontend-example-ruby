# frozen_string_literal: true

module Govuk
  class Component < ViewComponent::Base
    def initialize(name:, params: {})
      @name = name
      @params = params
    end

    def call
      html = Govuk.render(@name, Govuk::Params.params_from_mapping(stringify(@params)))
      html.html_safe # rubocop:disable Rails/OutputSafety -- trusted Govuk.render output
    end

    private

    def stringify(value)
      case value
      when Hash
        value.each_with_object({}) { |(k, v), h| h[k.to_s] = stringify(v) }
      when Array
        value.map { |item| stringify(item) }
      else
        value
      end
    end
  end
end

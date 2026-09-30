# frozen_string_literal: true

module ApplicationHelper
  def govuk(name, params = {})
    html = Govuk.render(name, Govuk::Params.params_from_mapping(deep_stringify_keys(params)))
    html.to_s.html_safe # rubocop:disable Rails/OutputSafety -- trusted Govuk.render output
  end

  def govuk_must(name, params = {})
    html = Govuk.must_render(name, Govuk::Params.params_from_mapping(deep_stringify_keys(params)))
    html.to_s.html_safe # rubocop:disable Rails/OutputSafety -- trusted Govuk.render output
  end

  def govuk_form(url: request.path, enctype: nil, &block)
    html = { novalidate: true }
    html[:enctype] = enctype if enctype.present?
    form_with url: url, method: :post, local: true, html: html, &block
  end

  def deep_stringify_keys(value)
    case value
    when Hash
      value.each_with_object({}) do |(key, item), result|
        result[key.to_s] = deep_stringify_keys(item)
      end
    when Array
      value.map { |item| deep_stringify_keys(item) }
    else
      value
    end
  end
end

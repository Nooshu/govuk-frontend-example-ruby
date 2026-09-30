# frozen_string_literal: true

require_relative "govuk/params"
require_relative "govuk/nunjucks"
require_relative "govuk/attributes"
require_relative "govuk/fixtures"
require_relative "govuk/catalogue"
require_relative "govuk/components_button"
require_relative "govuk/components_chrome"
require_relative "govuk/components_forms"
require_relative "govuk/components_lists"
require_relative "govuk/components_text"
require_relative "govuk/render"

module Govuk
  module_function

  def render(component, params)
    Render.call(component, params)
  end

  def must_render(component, params)
    Render.must_call(component, params)
  end

  def components
    Render.components
  end
end

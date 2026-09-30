# frozen_string_literal: true

module Govuk
  module Render
    module_function

    RENDERERS = {
      "accordion" => ->(p) { ComponentsLists.render_accordion(p) },
      "back-link" => ->(p) { ComponentsText.render_back_link(p) },
      "breadcrumbs" => ->(p) { ComponentsChrome.render_breadcrumbs(p) },
      "button" => ->(p) { ComponentsButton.render_button(p) },
      "character-count" => ->(p) { ComponentsForms.render_character_count(p) },
      "checkboxes" => ->(p) { ComponentsForms.render_checkboxes(p) },
      "cookie-banner" => ->(p) { ComponentsChrome.render_cookie_banner(p) },
      "date-input" => ->(p) { ComponentsForms.render_date_input(p) },
      "details" => ->(p) { ComponentsText.render_details(p) },
      "error-message" => ->(p) { ComponentsText.render_error_message(p) },
      "error-summary" => ->(p) { ComponentsLists.render_error_summary(p) },
      "exit-this-page" => ->(p) { ComponentsButton.render_exit_this_page(p) },
      "feedback" => ->(p) { ComponentsText.render_feedback(p) },
      "fieldset" => ->(p) { ComponentsText.render_fieldset(p) },
      "file-upload" => ->(p) { ComponentsForms.render_file_upload(p) },
      "footer" => ->(p) { ComponentsChrome.render_footer(p) },
      "generic-header" => ->(p) { ComponentsChrome.render_generic_header(p) },
      "header" => ->(p) { ComponentsChrome.render_header(p) },
      "hint" => ->(p) { ComponentsText.render_hint(p) },
      "input" => ->(p) { ComponentsForms.render_input(p) },
      "inset-text" => ->(p) { ComponentsText.render_inset_text(p) },
      "label" => ->(p) { ComponentsText.render_label(p) },
      "language-navigation" => ->(p) { ComponentsChrome.render_language_navigation(p) },
      "notification-banner" => ->(p) { ComponentsLists.render_notification_banner(p) },
      "pagination" => ->(p) { ComponentsChrome.render_pagination(p) },
      "panel" => ->(p) { ComponentsText.render_panel(p) },
      "password-input" => ->(p) { ComponentsForms.render_password_input(p) },
      "phase-banner" => ->(p) { ComponentsText.render_phase_banner(p) },
      "radios" => ->(p) { ComponentsForms.render_radios(p) },
      "select" => ->(p) { ComponentsForms.render_select(p) },
      "service-navigation" => ->(p) { ComponentsChrome.render_service_navigation(p) },
      "skip-link" => ->(p) { ComponentsText.render_skip_link(p) },
      "summary-list" => ->(p) { ComponentsLists.render_summary_list(p) },
      "table" => ->(p) { ComponentsLists.render_table(p) },
      "tabs" => ->(p) { ComponentsLists.render_tabs(p) },
      "tag" => ->(p) { ComponentsText.render_tag(p) },
      "task-list" => ->(p) { ComponentsLists.render_task_list(p) },
      "textarea" => ->(p) { ComponentsForms.render_textarea(p) },
      "warning-text" => ->(p) { ComponentsText.render_warning_text(p) }
    }.freeze

    def call(component, params)
      render = RENDERERS[component]
      raise ArgumentError, "govuk: #{component.inspect} is not a GOV.UK Frontend component" unless render

      params = Params.new if params.nil?
      render.call(params).strip
    end

    def must_call(component, params)
      call(component, params)
    end

    def components
      RENDERERS.keys.sort
    end
  end
end

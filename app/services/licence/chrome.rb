# frozen_string_literal: true

module Licence
  module Chrome
    module_function

    def page_title(heading, service_name, has_errors: false)
      prefix = has_errors ? "Error: " : ""
      "#{prefix}#{heading} – #{service_name}"
    end

    def crumbs(current)
      { "items" => [{ "href" => "/", "text" => "Home" }, { "text" => current }] }
    end

    def phase_banner(lang)
      if lang == "cy"
        {
          "tag" => { "text" => "Enghraifft" },
          "html" => Govuk::Safe.new(
            "Mae hon yn arddangosiad – nid gwasanaeth llywodraeth byw mohono. " \
            'Bydd eich <a class="govuk-link" href="/about">adborth</a> yn helpu ' \
            "i wella’r enghraifft."
          )
        }
      else
        {
          "tag" => { "text" => "Example" },
          "html" => Govuk::Safe.new(
            "This is a demonstration – it is not a live government service. Your " \
            '<a class="govuk-link" href="/about">feedback</a> will help us improve the example.'
          )
        }
      end
    end

    def demo_banner(lang)
      banner = { "classes" => "app-demo-banner", "titleId" => "app-demo-banner-title" }
      if lang == "cy"
        banner["titleText"] = "Pwysig"
        banner["text"] = "Mae hwn yn arddangosiad byw. Nid gwasanaeth llywodraeth go iawn mohono."
      else
        banner["titleText"] = "Important"
        banner["text"] = "This is a live demo. It is not a real government service."
      end
      banner
    end

    def feedback_options
      {
        "titleText" => "Help us improve this service",
        "html" => Govuk::Safe.new(
          '<p class="govuk-body">This example does not send feedback. ' \
          '<a class="govuk-link" href="/help">Get help with this example</a>.</p>'
        )
      }
    end

    def service_navigation(lang)
      service_name = Rails.configuration.service_name
      service_url = "/"
      aria_label = "Language"
      items = [
        { "text" => "English", "lang" => "en", "current" => true },
        { "text" => "Cymraeg", "lang" => "cy", "href" => "/cy" }
      ]
      if lang == "cy"
        service_name = Rails.configuration.service_name_cy
        service_url = "/cy"
        aria_label = "Iaith"
        items = [
          { "text" => "English", "lang" => "en", "href" => "/" },
          { "text" => "Cymraeg", "lang" => "cy", "current" => true }
        ]
      end
      languages = Govuk.must_render(
        "language-navigation",
        Govuk::Params.params_from_mapping({ "ariaLabel" => aria_label, "items" => items })
      )
      {
        "serviceName" => service_name,
        "serviceUrl" => service_url,
        "slots" => { "end" => Govuk::Safe.new(languages) }
      }
    end

    def footer_options(lang)
      items = [
        { "href" => "/help", "text" => "Help" },
        { "href" => "/fees", "text" => "Licence fees" },
        { "href" => "/updates", "text" => "Service updates" },
        { "href" => "/guidance", "text" => "Guidance" },
        { "href" => "/cookies", "text" => "Cookies" },
        { "href" => "/accessibility", "text" => "Accessibility" },
        { "href" => "/about", "text" => "About this example" }
      ]
      if Rails.configuration.demos_enabled
        items.push(
          { "href" => "/components", "text" => "Component catalogue" },
          { "href" => "/examples", "text" => "Example pages" }
        )
      end
      footer = { "meta" => { "items" => items } }
      if lang == "cy"
        footer["contentLicence"] = {
          "html" => Govuk::Safe.new(
            "Mae’r holl gynnwys ar gael dan " \
            '<a class="govuk-footer__link" ' \
            'href="https://www.nationalarchives.gov.uk/doc/open-government-licence-cymraeg/' \
            'version/3/" rel="license">Drwydded y Llywodraeth Agored v3.0</a>, ' \
            "ac eithrio lle nodir yn wahanol"
          )
        }
        footer["copyright"] = { "html" => Govuk::Safe.new("<span>Hawlfraint y Goron</span>") }
      end
      footer
    end

    def cookie_banner_options(session)
      banner_state = SessionState.get_cookie_banner(session)
      return confirmation_banner("You have accepted analytics cookies.") if banner_state == SessionState::CHOICE_ACCEPT
      return confirmation_banner("You have rejected analytics cookies.") if banner_state == SessionState::CHOICE_REJECT
      return nil unless SessionState.get_cookie_choice(session).empty?

      {
        "messages" => [
          {
            "headingText" => "Cookies on Apply for a fishing rod licence",
            "text" =>
              "We use analytics cookies to understand how you use this example service. " \
              "This example does not set analytics cookies.",
            "actions" => [
              { "text" => "Accept analytics cookies", "type" => "submit", "name" => "cookies", "value" => "accept" },
              { "text" => "Reject analytics cookies", "type" => "submit", "name" => "cookies", "value" => "reject" },
              { "text" => "View cookies", "href" => "/cookies" }
            ]
          }
        ]
      }
    end

    def confirmation_banner(text)
      {
        "messages" => [
          {
            "text" => text,
            "role" => "alert",
            "actions" => [
              { "text" => "Hide cookie message", "type" => "submit", "name" => "cookies", "value" => "hide" }
            ]
          }
        ]
      }
    end
    private_class_method :confirmation_banner

    def safe_return_path(value)
      value = value.to_s
      if !value.start_with?("/") || value.start_with?("//") || value.include?("://") ||
         value.include?("\\") || value.include?("\r") || value.include?("\n")
        return "/"
      end

      value
    end

    def layout_context(request, heading:, lang: "en", has_errors: false, back_link: nil, breadcrumbs: nil,
                       main_classes: "", show_feedback: false, personal: false, exit_this_page: nil)
      raise ArgumentError, "page cannot set both a back link and breadcrumbs" if back_link && breadcrumbs

      service_name = lang == "cy" ? Rails.configuration.service_name_cy : Rails.configuration.service_name
      skip = lang == "cy" ? "Neidio i'r prif gynnwys" : "Skip to main content"
      homepage = lang == "cy" ? "/cy" : "/"
      return_path = safe_return_path(request.fullpath)
      assets = Assets.load_page_assets

      {
        heading: heading,
        page_title: page_title(heading, service_name, has_errors: has_errors),
        html_lang: lang,
        skip_link_text: skip,
        skip_link: { "href" => "#main-content", "text" => skip },
        header: { "homepageUrl" => homepage },
        homepage_url: homepage,
        main_classes: main_classes,
        return_path: return_path,
        service_navigation: service_navigation(lang),
        phase_banner: phase_banner(lang),
        demo_banner: demo_banner(lang),
        footer: footer_options(lang),
        cookie_banner: cookie_banner_options(request.session),
        feedback: feedback_options,
        back_link: back_link,
        breadcrumbs: breadcrumbs,
        exit_this_page: exit_this_page,
        show_feedback: show_feedback,
        personal: personal,
        frontend_version: Rails.configuration.govuk_frontend_version,
        stylesheet_href: assets.stylesheet_href,
        app_module_href: assets.app_module_href,
        js_enabled_snippet: Baseline::Policy.js_enabled_snippet,
        demos_enabled: Rails.configuration.demos_enabled
      }
    end
  end
end

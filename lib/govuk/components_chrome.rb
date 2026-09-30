# frozen_string_literal: true

# Auto-ported from Python for GOV.UK Frontend fixture parity.
# Source: govuk_components/rendering/components_chrome.py
module Govuk
  module ComponentsChrome
    module_function
    
    LOGO_CROWN = "    <g>\n      <circle cx=\"20\" cy=\"17.6\" r=\"3.7\"/>\n      <circle cx=\"10.2\" cy=\"23.5\" r=\"3.7\"/>\n      <circle cx=\"3.7\" cy=\"33.2\" r=\"3.7\"/>\n      <circle cx=\"31.7\" cy=\"30.6\" r=\"3.7\"/>\n      <circle cx=\"43.3\" cy=\"17.6\" r=\"3.7\"/>\n      <circle cx=\"53.2\" cy=\"23.5\" r=\"3.7\"/>\n      <circle cx=\"59.7\" cy=\"33.2\" r=\"3.7\"/>\n      <circle cx=\"31.7\" cy=\"30.6\" r=\"3.7\"/>\n      <path d=\"M33.1,9.8c.2-.1.3-.3.5-.5l4.6,2.4v-6.8l-4.6,1.5c-.1-.2-.3-.3-.5-.5l1.9-5.9h-6.7l1.9,5.9c-.2.1-.3.3-.5.5l-4.6-1.5v6.8l4.6-2.4c.1.2.3.3.5.5l-2.6,8c-.9,2.8,1.2,5.7,4.1,5.7h0c3,0,5.1-2.9,4.1-5.7l-2.6-8ZM37,37.9s-3.4,3.8-4.1,6.1c2.2,0,4.2-.5,6.4-2.8l-.7,8.5c-2-2.8-4.4-4.1-5.7-3.8.1,3.1.5,6.7,5.8,7.2,3.7.3,6.7-1.5,7-3.8.4-2.6-2-4.3-3.7-1.6-1.4-4.5,2.4-6.1,4.9-3.2-1.9-4.5-1.8-7.7,2.4-10.9,3,4,2.6,7.3-1.2,11.1,2.4-1.3,6.2,0,4,4.6-1.2-2.8-3.7-2.2-4.2.2-.3,1.7.7,3.7,3,4.2,1.9.3,4.7-.9,7-5.9-1.3,0-2.4.7-3.9,1.7l2.4-8c.6,2.3,1.4,3.7,2.2,4.5.6-1.6.5-2.8,0-5.3l5,1.8c-2.6,3.6-5.2,8.7-7.3,17.5-7.4-1.1-15.7-1.7-24.5-1.7h0c-8.8,0-17.1.6-24.5,1.7-2.1-8.9-4.7-13.9-7.3-17.5l5-1.8c-.5,2.5-.6,3.7,0,5.3.8-.8,1.6-2.3,2.2-4.5l2.4,8c-1.5-1-2.6-1.7-3.9-1.7,2.3,5,5.2,6.2,7,5.9,2.3-.4,3.3-2.4,3-4.2-.5-2.4-3-3.1-4.2-.2-2.2-4.6,1.6-6,4-4.6-3.7-3.7-4.2-7.1-1.2-11.1,4.2,3.2,4.3,6.4,2.4,10.9,2.5-2.8,6.3-1.3,4.9,3.2-1.8-2.7-4.1-1-3.7,1.6.3,2.3,3.3,4.1,7,3.8,5.4-.5,5.7-4.2,5.8-7.2-1.3-.2-3.7,1-5.7,3.8l-.7-8.5c2.2,2.3,4.2,2.7,6.4,2.8-.7-2.3-4.1-6.1-4.1-6.1h10.6,0Z\"/>\n    </g>"
    
    LOGO_LOGOTYPE = "    <circle class=\"govuk-logo-dot\" cx=\"226\" cy=\"36\" r=\"7.3\"/>\n    <path d=\"M93.94 41.25c.4 1.81 1.2 3.21 2.21 4.62 1 1.4 2.21 2.41 3.61 3.21s3.21 1.2 5.22 1.2 3.61-.4 4.82-1c1.4-.6 2.41-1.4 3.21-2.41.8-1 1.4-2.01 1.61-3.01s.4-2.01.4-3.01v.14h-10.86v-7.02h20.07v24.08h-8.03v-5.56c-.6.8-1.38 1.61-2.19 2.41-.8.8-1.81 1.2-2.81 1.81-1 .4-2.21.8-3.41 1.2s-2.41.4-3.81.4a18.56 18.56 0 0 1-14.65-6.63c-1.6-2.01-3.01-4.41-3.81-7.02s-1.4-5.62-1.4-8.83.4-6.02 1.4-8.83a20.45 20.45 0 0 1 19.46-13.65c3.21 0 4.01.2 5.82.8 1.81.4 3.61 1.2 5.02 2.01 1.61.8 2.81 2.01 4.01 3.21s2.21 2.61 2.81 4.21l-7.63 4.41c-.4-1-1-1.81-1.61-2.61-.6-.8-1.4-1.4-2.21-2.01-.8-.6-1.81-1-2.81-1.4-1-.4-2.21-.4-3.61-.4-2.01 0-3.81.4-5.22 1.2-1.4.8-2.61 1.81-3.61 3.21s-1.61 2.81-2.21 4.62c-.4 1.81-.6 3.71-.6 5.42s.8 5.22.8 5.22Zm57.8-27.9c3.21 0 6.22.6 8.63 1.81 2.41 1.2 4.82 2.81 6.62 4.82S170.2 24.39 171 27s1.4 5.62 1.4 8.83-.4 6.02-1.4 8.83-2.41 5.02-4.01 7.02-4.01 3.61-6.62 4.82-5.42 1.81-8.63 1.81-6.22-.6-8.63-1.81-4.82-2.81-6.42-4.82-3.21-4.41-4.01-7.02-1.4-5.62-1.4-8.83.4-6.02 1.4-8.83 2.41-5.02 4.01-7.02 4.01-3.61 6.42-4.82 5.42-1.81 8.63-1.81Zm0 36.73c1.81 0 3.61-.4 5.02-1s2.61-1.81 3.61-3.01 1.81-2.81 2.21-4.41c.4-1.81.8-3.61.8-5.62 0-2.21-.2-4.21-.8-6.02s-1.2-3.21-2.21-4.62c-1-1.2-2.21-2.21-3.61-3.01s-3.21-1-5.02-1-3.61.4-5.02 1c-1.4.8-2.61 1.81-3.61 3.01s-1.81 2.81-2.21 4.62c-.4 1.81-.8 3.61-.8 5.62 0 2.41.2 4.21.8 6.02.4 1.81 1.2 3.21 2.21 4.41s2.21 2.21 3.61 3.01c1.4.8 3.21 1 5.02 1Zm36.32 7.96-12.24-44.15h9.83l8.43 32.77h.4l8.23-32.77h9.83L200.3 58.04h-12.24Zm74.14-7.96c2.18 0 3.51-.6 3.51-.6 1.2-.6 2.01-1 2.81-1.81s1.4-1.81 1.81-2.81a13 13 0 0 0 .8-4.01V13.9h8.63v28.15c0 2.41-.4 4.62-1.4 6.62-.8 2.01-2.21 3.61-3.61 5.02s-3.41 2.41-5.62 3.21-4.62 1.2-7.02 1.2-5.02-.4-7.02-1.2c-2.21-.8-4.01-1.81-5.62-3.21s-2.81-3.01-3.61-5.02-1.4-4.21-1.4-6.62V13.9h8.63v26.95c0 1.61.2 3.01.8 4.01.4 1.2 1.2 2.21 2.01 2.81.8.8 1.81 1.4 2.81 1.81 0 0 1.34.6 3.51.6Zm34.22-36.18v18.92l15.65-18.92h10.82l-15.03 17.32 16.03 26.83h-10.21l-11.44-20.21-5.62 6.22v13.99h-8.83V13.9\"/>"
    
    FOOTER_LICENCE_LOGO = "<svg\n            aria-hidden=\"true\"\n            focusable=\"false\"\n            class=\"govuk-footer__licence-logo\"\n            xmlns=\"http://www.w3.org/2000/svg\"\n            viewBox=\"0 0 483.2 195.7\"\n            height=\"17\"\n            width=\"41\"\n          >\n            <path\n              fill=\"currentColor\"\n              d=\"M421.5 142.8V.1l-50.7 32.3v161.1h112.4v-50.7zm-122.3-9.6A47.12 47.12 0 0 1 221 97.8c0-26 21.1-47.1 47.1-47.1 16.7 0 31.4 8.7 39.7 21.8l42.7-27.2A97.63 97.63 0 0 0 268.1 0c-36.5 0-68.3 20.1-85.1 49.7A98 98 0 0 0 97.8 0C43.9 0 0 43.9 0 97.8s43.9 97.8 97.8 97.8c36.5 0 68.3-20.1 85.1-49.7a97.76 97.76 0 0 0 149.6 25.4l19.4 22.2h3v-87.8h-80l24.3 27.5zM97.8 145c-26 0-47.1-21.1-47.1-47.1s21.1-47.1 47.1-47.1 47.2 21 47.2 47S123.8 145 97.8 145\"\n            />\n          </svg>"
    
    FOOTER_COPYRIGHT_HREF = "https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/"
    
    PAGINATION_ARROW_PREVIOUS = "  <svg class=\"govuk-pagination__icon govuk-pagination__icon--prev\" xmlns=\"http://www.w3.org/2000/svg\" height=\"13\" width=\"15\" aria-hidden=\"true\" focusable=\"false\" viewBox=\"0 0 15 13\">\n    <path d=\"m6.5938-0.0078125-6.7266 6.7266 6.7441 6.4062 1.377-1.449-4.1856-3.9768h12.896v-2h-12.984l4.2931-4.293-1.414-1.414z\"></path>\n  </svg>"
    
    PAGINATION_ARROW_NEXT = "  <svg class=\"govuk-pagination__icon govuk-pagination__icon--next\" xmlns=\"http://www.w3.org/2000/svg\" height=\"13\" width=\"15\" aria-hidden=\"true\" focusable=\"false\" viewBox=\"0 0 15 13\">\n    <path d=\"m8.107-0.0078125-1.4136 1.414 4.2926 4.293h-12.986v2h12.896l-4.1855 3.9766 1.377 1.4492 6.7441-6.4062-6.7246-6.7266z\"></path>\n  </svg>"
    
    def render_logo(p)
      use_logotype = Nunjucks.truthy?(Nunjucks.default(p.get("useLogotype"), true))
      width = "32"
      view_box = "64"
      if use_logotype
        width = "162"
        view_box = "324"
      end
      role = "presentation"
      aria_label = p.get("ariaLabelText")
      if Nunjucks.truthy?(aria_label)
        role = "img"
      end
      parts = []
      (parts << ((((((((((((("\n  <svg\n    focusable=\"false\"\n    role=\"" + role) + "\"\n") + "    xmlns=\"http://www.w3.org/2000/svg\"\n") + "    viewBox=\"0 0 ") + view_box) + " 60\"\n    height=\"30\"\n    width=\"") + width) + "\"\n") + "    fill=\"currentcolor\"") + Attributes.attribute_if("class", p.get("classes"))) + Attributes.attribute_if("aria-label", aria_label)) + Attributes.attributes(p.get("attributes"))) + "\n  >"))
      if Nunjucks.truthy?(aria_label)
        (parts << (("<title>" + Nunjucks.out(aria_label)) + "</title>"))
      end
      (parts << (("    " + Nunjucks.indent(Nunjucks.trim(LOGO_CROWN), 2, false)) + "\n"))
      if use_logotype
        (parts << (("      " + Nunjucks.indent(Nunjucks.trim(LOGO_LOGOTYPE), 2, false)) + "\n"))
      end
      (parts << "  </svg>\n")
      return parts.join("")
    end
    
    def render_generic_header(p)
      namespace = Nunjucks.out(Nunjucks.default(p.get("_namespace"), "govuk-generic"))
      return ((((((((((((((((((((((("<div class=\"" + namespace) + "-header") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n") + "  <div class=\"") + namespace) + "-header__container ") + Nunjucks.out(Nunjucks.default_truthy(p.get("containerClasses"), "govuk-width-container"))) + "\">\n") + "    <div class=\"") + namespace) + "-header__logo\">\n") + "      <a href=\"") + Nunjucks.out(Nunjucks.default_truthy(p.get("url"), "/"))) + "\" class=\"") + namespace) + "-header__homepage-link\">\n") + "        ") + Attributes.content(p, "logoHtml", "logoText")) + "\n") + "      </a>\n    </div>\n  </div>\n</div>")
    end
    
    def render_header(p)
      logo = render_logo(Params.new_params("classes", "govuk-header__logotype", "ariaLabelText", "GOV.UK"))
      logo_content = (("  " + Nunjucks.trim(logo)) + "\n")
      product_name = p.get("productName")
      if Nunjucks.truthy?(product_name)
        logo_content += (("<span class=\"govuk-header__product-name\">" + Nunjucks.out(product_name)) + "</span>")
      end
      return render_generic_header(Params.new_params("_namespace", "govuk", "logoHtml", Safe.new(Nunjucks.indent(logo_content, 8, false)), "url", Nunjucks.default_truthy(p.get("homepageUrl"), "//gov.uk"), "containerClasses", p.get("containerClasses"), "classes", p.get("classes"), "attributes", p.get("attributes")))
    end
    
    def render_footer(p)
      parts = []
      (parts << (((("<div class=\"govuk-footer" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      (parts << (("  <div class=\"govuk-width-container" + Attributes.classes_if(p.get("containerClasses"))) + "\">"))
      (parts << render_logo(Params.new_params("classes", "govuk-footer__crown", "useLogotype", false)))
      (parts << "\n")
      navigation = Nunjucks.items(p.get("navigation"))
      if (navigation.length > 0)
        (parts << "      <div class=\"govuk-footer__navigation\">\n")
        navigation.each do |nav|
          (parts << (("          <div class=\"govuk-footer__section govuk-grid-column-" + Nunjucks.out(Nunjucks.default_truthy(Nunjucks.get(nav, "width"), "full"))) + "\">\n"))
          (parts << (("            <h2 class=\"govuk-footer__heading govuk-heading-m\">" + Nunjucks.out(Nunjucks.get(nav, "title"))) + "</h2>\n"))
          links = Nunjucks.items(Nunjucks.get(nav, "items"))
          if (links.length > 0)
            list_classes = ""
            columns = Nunjucks.get(nav, "columns")
            if Nunjucks.truthy?(columns)
              list_classes = (" govuk-footer__list--columns-" + Nunjucks.escape(Nunjucks.str_value(columns)))
            end
            (parts << (("              <ul class=\"govuk-footer__list" + list_classes) + "\">\n"))
            links.each do |link|
              if (!(Nunjucks.truthy?(Nunjucks.get(link, "href"))) || !(Nunjucks.truthy?(Nunjucks.get(link, "text"))))
                next
              end
              (parts << "                    <li class=\"govuk-footer__list-item\">\n")
              (parts << (((("                      <a class=\"govuk-footer__link\" href=\"" + Nunjucks.out(Nunjucks.get(link, "href"))) + "\"") + Attributes.attributes(Nunjucks.get(link, "attributes"))) + ">\n"))
              (parts << (("                        " + Nunjucks.out(Nunjucks.get(link, "text"))) + "\n"))
              (parts << "                      </a>\n                    </li>\n")
            end
            (parts << "              </ul>\n")
          end
          (parts << "          </div>\n")
        end
        (parts << "      </div>\n")
        (parts << "      <hr class=\"govuk-footer__section-break\">\n")
      end
      (parts << "    <div class=\"govuk-footer__meta\">\n")
      (parts << "      <div class=\"govuk-footer__meta-item govuk-footer__meta-item--grow\">\n")
      meta = p.get("meta")
      if Nunjucks.truthy?(meta)
        (parts << (("        <h2 class=\"govuk-visually-hidden\">" + Nunjucks.out(Nunjucks.default_truthy(Nunjucks.get(meta, "visuallyHiddenTitle"), "Support links"))) + "</h2>\n"))
        links = Nunjucks.items(Nunjucks.get(meta, "items"))
        if (links.length > 0)
          (parts << "        <ul class=\"govuk-footer__inline-list\">\n")
          links.each do |link|
            (parts << "          <li class=\"govuk-footer__inline-list-item\">\n")
            (parts << (((("            <a class=\"govuk-footer__link\" href=\"" + Nunjucks.out(Nunjucks.get(link, "href"))) + "\"") + Attributes.attributes(Nunjucks.get(link, "attributes"))) + ">\n"))
            (parts << (("              " + Nunjucks.out(Nunjucks.get(link, "text"))) + "\n"))
            (parts << "            </a>\n          </li>\n")
          end
          (parts << "        </ul>\n")
        end
        if (Nunjucks.truthy?(Nunjucks.get(meta, "text")) || Nunjucks.truthy?(Nunjucks.get(meta, "html")))
          (parts << "        <div class=\"govuk-footer__meta-custom\">\n")
          (parts << (("          " + Attributes.content_indent(meta, "html", "text", 10)) + "\n"))
          (parts << "        </div>\n")
        end
      end
      licence = p.get("contentLicence")
      if !licence.nil?
        (parts << (("          " + FOOTER_LICENCE_LOGO) + "\n"))
        (parts << "          <span class=\"govuk-footer__licence-description\">\n")
        if (Nunjucks.truthy?(Nunjucks.get(licence, "html")) || Nunjucks.truthy?(Nunjucks.get(licence, "text")))
          (parts << (("            " + Attributes.content_indent(licence, "html", "text", 12)) + "\n"))
        else
          (parts << "            All content is available under the\n            <a\n              class=\"govuk-footer__link\"\n              href=\"https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/\"\n              rel=\"license\"\n            >Open Government Licence v3.0</a>, except where otherwise stated\n")
        end
        (parts << "          </span>\n")
      end
      (parts << "      </div>\n")
      (parts << "      <div class=\"govuk-footer__meta-item\">\n")
      (parts << (("        <a\n          class=\"govuk-footer__link govuk-footer__copyright-logo\"\n          href=\"" + FOOTER_COPYRIGHT_HREF) + "\"\n        >\n"))
      copyright_ = p.get("copyright")
      if (Nunjucks.truthy?(Nunjucks.get(copyright_, "html")) || Nunjucks.truthy?(Nunjucks.get(copyright_, "text")))
        (parts << (("          " + Attributes.content_indent(copyright_, "html", "text", 10)) + "\n"))
      else
        (parts << "          © Crown copyright\n")
      end
      (parts << "        </a>\n      </div>\n")
      (parts << "    </div>\n  </div>\n</div>")
      return parts.join("")
    end
    
    def render_breadcrumbs(p)
      class_names = "govuk-breadcrumbs"
      classes = p.get("classes")
      if Nunjucks.truthy?(classes)
        class_names += (" " + Nunjucks.str_value(classes))
      end
      if Nunjucks.truthy?(p.get("collapseOnMobile"))
        class_names += " govuk-breadcrumbs--collapse-on-mobile"
      end
      parts = []
      (parts << (((((("<nav class=\"" + Nunjucks.escape(class_names)) + "\"") + Attributes.attributes(p.get("attributes"))) + " aria-label=\"") + Nunjucks.out(Nunjucks.default(p.get("labelText"), "Breadcrumb"))) + "\">\n"))
      (parts << "  <ol class=\"govuk-breadcrumbs__list\">\n")
      Nunjucks.items(p.get("items")).each do |item|
        href = Nunjucks.get(item, "href")
        if Nunjucks.truthy?(href)
          (parts << "    <li class=\"govuk-breadcrumbs__list-item\">\n")
          (parts << (((((("      <a class=\"govuk-breadcrumbs__link\" href=\"" + Nunjucks.out(href)) + "\"") + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + Attributes.content(item, "html", "text")) + "</a>\n"))
          (parts << "    </li>\n")
        else
          (parts << (("    <li class=\"govuk-breadcrumbs__list-item\" aria-current=\"page\">" + Attributes.content(item, "html", "text")) + "</li>\n"))
        end
      end
      (parts << "  </ol>\n</nav>")
      return parts.join("")
    end
    
    def render_language_navigation(p)
      parts = []
      (parts << (((((("<nav class=\"govuk-language-navigation" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + " aria-label=\"") + Nunjucks.out(Nunjucks.default(p.get("ariaLabel"), "Language"))) + "\">\n"))
      (parts << "  <ul class=\"govuk-language-navigation__list\">\n")
      Nunjucks.items(p.get("items")).each do |item|
        href = Nunjucks.get(item, "href")
        (parts << "    <li class=\"govuk-language-navigation__list-item\">\n")
        if (Nunjucks.truthy?(Nunjucks.get(item, "current")) || !(Nunjucks.truthy?(href)))
          (parts << (((((((("      <span class=\"govuk-language-navigation__text" + Attributes.classes_if(Nunjucks.get(item, "classes"))) + "\"\n        aria-current=\"true\"") + Attributes.attribute_if("lang", Nunjucks.get(item, "lang"))) + Attributes.attribute_if("dir", Nunjucks.get(item, "dir"))) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + Attributes.content(item, "html", "text")) + "</span>\n"))
        else
          href_lang = Nunjucks.get(item, "hrefLang")
          if !(Nunjucks.truthy?(href_lang))
            href_lang = Nunjucks.get(item, "lang")
          end
          (parts << (((((((((("      <a class=\"govuk-language-navigation__link" + Attributes.classes_if(Nunjucks.get(item, "classes"))) + "\" href=\"") + Nunjucks.out(href)) + "\" rel=\"alternate\"") + Attributes.attribute_if("lang", Nunjucks.get(item, "lang"))) + Attributes.attribute_if("hreflang", href_lang)) + Attributes.attribute_if("dir", Nunjucks.get(item, "dir"))) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + Attributes.content(item, "html", "text")))
          description = Nunjucks.get(item, "languageDescriptionText")
          if Nunjucks.truthy?(description)
            (parts << (("<span class=\"govuk-visually-hidden\"> " + Nunjucks.out(description)) + "</span>"))
          end
          (parts << "      </a>\n")
        end
        (parts << "    </li>\n")
      end
      (parts << "  </ul>\n</nav>")
      return parts.join("")
    end
    
    def render_service_navigation(p)
      slots = p.get("slots")
      menu_button_text = Nunjucks.default_truthy(p.get("menuButtonText"), "Menu")
      navigation_id = Nunjucks.out(Nunjucks.default_truthy(p.get("navigationId"), "navigation"))
      end_slot = Nunjucks.get(slots, "end")
      end_slot_html = Nunjucks.get(end_slot, "html")
      if end_slot.is_a?(String)
        end_slot_html = end_slot
      end
      end_slot_is_object = end_slot.is_a?(Params)
      end_slot_inline = (end_slot_is_object && Nunjucks.loose_eq(end_slot.get("align"), "inline"))
      common_attributes = ((((("class=\"govuk-service-navigation" + Attributes.classes_if(p.get("classes"))) + "\"\n") + "data-module=\"govuk-service-navigation\"") + Attributes.attributes(p.get("attributes"))) + "\n")
      inner = []
      (inner << (("  <div class=\"govuk-width-container" + Attributes.flag_if(" govuk-service-navigation__inlining-container", end_slot_inline)) + "\">\n\n    "))
      start = Nunjucks.get(slots, "start")
      if Nunjucks.truthy?(start)
        (inner << Nunjucks.str_value(start))
      end
      (inner << "<div class=\"govuk-service-navigation__container\">\n      \n")
      service_name = p.get("serviceName")
      if Nunjucks.truthy?(service_name)
        (inner << "        <span class=\"govuk-service-navigation__service-name\">\n")
        service_url = p.get("serviceUrl")
        if Nunjucks.truthy?(service_url)
          (inner << (("            <a href=\"" + Nunjucks.out(service_url)) + "\" class=\"govuk-service-navigation__link\">\n"))
          (inner << (("              " + Nunjucks.out(service_name)) + "\n            </a>\n"))
        else
          (inner << (("            <span class=\"govuk-service-navigation__text\">" + Nunjucks.out(service_name)) + "</span>\n"))
        end
        (inner << "        </span>\n")
      end
      (inner << "\n      \n")
      navigation_items = []
      Nunjucks.items(p.get("navigation")).each do |item|
        if Nunjucks.truthy?(item)
          (navigation_items << item)
        end
      end
      collapse = Nunjucks.truthy?(Nunjucks.default(p.get("collapseNavigationOnMobile"), (navigation_items.length > 1)))
      navigation_start = Nunjucks.get(slots, "navigationStart")
      navigation_end = Nunjucks.get(slots, "navigationEnd")
      if ((navigation_items.length > 0) || Nunjucks.truthy?(navigation_start) || Nunjucks.truthy?(navigation_end))
        (inner << (((("        <nav aria-label=\"" + Nunjucks.out(Nunjucks.default_truthy(p.get("navigationLabel"), menu_button_text))) + "\" class=\"govuk-service-navigation__wrapper") + Attributes.classes_if(p.get("navigationClasses"))) + "\">\n"))
        if collapse
          menu_button_label = p.get("menuButtonLabel")
          aria_label = ""
          if (Nunjucks.truthy?(menu_button_label) && !(Nunjucks.loose_eq(menu_button_label, menu_button_text)))
            aria_label = ((" aria-label=\"" + Nunjucks.out(menu_button_label)) + "\"")
          end
          (inner << (((("          <button type=\"button\" class=\"govuk-service-navigation__toggle govuk-js-service-navigation-toggle\" aria-controls=\"" + navigation_id) + "\"") + aria_label) + " hidden aria-hidden=\"true\">\n"))
          (inner << (("            " + Nunjucks.out(menu_button_text)) + "\n          </button>\n"))
        end
        (inner << (("\n          <ul class=\"govuk-service-navigation__list\" id=\"" + navigation_id) + "\" >\n\n            "))
        if Nunjucks.truthy?(navigation_start)
          (inner << Nunjucks.str_value(navigation_start))
        end
        (inner << "\n")
        navigation_items.each do |item|
          active = (Nunjucks.truthy?(Nunjucks.get(item, "active")) || Nunjucks.truthy?(Nunjucks.get(item, "current")))
          if active
            link_inner = (("\n                                    \n                  <strong class=\"govuk-service-navigation__active-fallback\">" + Attributes.content(item, "html", "text")) + "</strong>\n")
          else
            link_inner = ("\n                                    \n" + Attributes.content(item, "html", "text"))
          end
          aria_current = ""
          if active
            value = "true"
            if Nunjucks.truthy?(Nunjucks.get(item, "current"))
              value = "page"
            end
            aria_current = ((" aria-current=\"" + value) + "\"")
          end
          (inner << "              \n")
          (inner << (("              <li class=\"govuk-service-navigation__item" + Attributes.flag_if(" govuk-service-navigation__item--active", active)) + "\">\n"))
          href = Nunjucks.get(item, "href")
          if Nunjucks.truthy?(href)
            (inner << ((((((("                  <a class=\"govuk-service-navigation__link\" href=\"" + Nunjucks.out(href)) + "\"") + aria_current) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + link_inner) + "\n                  </a>\n"))
          elsif (Nunjucks.truthy?(Nunjucks.get(item, "html")) || Nunjucks.truthy?(Nunjucks.get(item, "text")))
            (inner << (((("                  <span class=\"govuk-service-navigation__text\"" + aria_current) + ">") + link_inner) + "\n                  </span>\n"))
          end
          (inner << "              </li>\n\n")
        end
        (inner << "            ")
        if Nunjucks.truthy?(navigation_end)
          (inner << Nunjucks.str_value(navigation_end))
        end
        (inner << "</ul>\n        </nav>\n")
      end
      (inner << "    </div>\n\n    ")
      if Nunjucks.truthy?(end_slot_html)
        (inner << Nunjucks.str_value(end_slot_html))
      end
      (inner << "</div>\n")
      if (Nunjucks.truthy?(p.get("serviceName")) || Nunjucks.truthy?(Nunjucks.get(slots, "start")) || Nunjucks.truthy?(end_slot_html))
        return (((((("  <section aria-label=\"" + Nunjucks.out(Nunjucks.default(p.get("ariaLabel"), "Service information"))) + "\" ") + common_attributes) + ">\n    ") + inner.join("")) + "\n  </section>\n")
      end
      return (((("  <div " + common_attributes) + ">\n    ") + inner.join("")) + "\n  </div>\n")
    end
    
    def render_pagination(p)
      previous, next_ = [p.get("previous"), p.get("next")]
      block_level = (!(Nunjucks.truthy?(p.get("items"))) && (Nunjucks.truthy?(next_) || Nunjucks.truthy?(previous)))
      parts = []
      (parts << ((((((("<nav class=\"govuk-pagination" + Attributes.flag_if(" govuk-pagination--block", block_level)) + Attributes.classes_if(p.get("classes"))) + "\" aria-label=\"") + Nunjucks.out(Nunjucks.default_truthy(p.get("landmarkLabel"), "Pagination"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      if (Nunjucks.truthy?(previous) && Nunjucks.truthy?(Nunjucks.get(previous, "href")))
        (parts << _pagination_arrow_link(previous, "prev", block_level, _pagination_link_label(previous, "Previous")))
      end
      entries = p.get("items")
      if Nunjucks.truthy?(entries)
        (parts << "  <ul class=\"govuk-pagination__list\">\n")
        Nunjucks.items(entries).each do |item|
          if (item.nil? || (Nunjucks.length(item) == 0))
            next
          end
          (parts << (("      " + Nunjucks.indent(_pagination_page_item(item), 2, false)) + "\n"))
        end
        (parts << "  </ul>\n")
      end
      if (Nunjucks.truthy?(next_) && Nunjucks.truthy?(Nunjucks.get(next_, "href")))
        (parts << _pagination_arrow_link(next_, "next", block_level, _pagination_link_label(next_, "Next")))
      end
      (parts << "</nav>")
      return parts.join("")
    end
    
    def _pagination_link_label(link, fallback)
      html, text = [Nunjucks.get(link, "html"), Nunjucks.get(link, "text")]
      if Nunjucks.truthy?(html)
        return Nunjucks.trim(Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), 8, false))
      end
      if Nunjucks.truthy?(text)
        return Nunjucks.out(text)
      end
      return (fallback + "<span class=\"govuk-visually-hidden\"> page</span>")
    end
    
    def _pagination_arrow_link(link, kind, block_level, label)
      arrow = PAGINATION_ARROW_NEXT
      if (kind == "prev")
        arrow = PAGINATION_ARROW_PREVIOUS
      end
      parts = []
      (parts << (("  <div class=\"govuk-pagination__" + kind) + "\">\n"))
      (parts << (((((("    <a class=\"govuk-link govuk-pagination__link\" href=\"" + Nunjucks.out(Nunjucks.get(link, "href"))) + "\" rel=\"") + kind) + "\"") + Attributes.attributes(Nunjucks.get(link, "attributes"))) + ">\n"))
      if (block_level || (kind == "prev"))
        (parts << (Nunjucks.indent(arrow, 4, true) + "\n"))
      end
      label_text = Nunjucks.get(link, "labelText")
      (parts << (((("      <span class=\"govuk-pagination__link-title" + Attributes.flag_if(" govuk-pagination__link-title--decorated", (block_level && !(Nunjucks.truthy?(label_text))))) + "\">\n        ") + label) + "\n      </span>\n"))
      if (Nunjucks.truthy?(label_text) && block_level)
        (parts << "      <span class=\"govuk-visually-hidden\">:</span>\n")
        (parts << (("      <span class=\"govuk-pagination__link-label\">" + Nunjucks.out(label_text)) + "</span>\n"))
      end
      if (!(block_level) && (kind == "next"))
        (parts << (Nunjucks.indent(arrow, 4, true) + "\n"))
      end
      (parts << "    </a>\n  </div>\n")
      return parts.join("")
    end
    
    def _pagination_page_item(item)
      parts = []
      (parts << ((("<li class=\"govuk-pagination__item" + Attributes.flag_if(" govuk-pagination__item--current", Nunjucks.get(item, "current"))) + Attributes.flag_if(" govuk-pagination__item--ellipsis", Nunjucks.get(item, "ellipsis"))) + "\">\n"))
      if Nunjucks.truthy?(Nunjucks.get(item, "ellipsis"))
        (parts << "    &ctdot;\n")
      else
        (parts << ((((((("    <a class=\"govuk-link govuk-pagination__link\" href=\"" + Nunjucks.out(Nunjucks.get(item, "href"))) + "\" aria-label=\"") + Nunjucks.out(Nunjucks.default(Nunjucks.get(item, "visuallyHiddenText"), ("Page " + Nunjucks.str_value(Nunjucks.get(item, "number")))))) + "\"") + Attributes.flag_if(" aria-current=\"page\"", Nunjucks.get(item, "current"))) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">\n"))
        (parts << (("      " + Nunjucks.out(Nunjucks.get(item, "number"))) + "\n    </a>\n"))
      end
      (parts << "  </li>")
      return parts.join("")
    end
    
    def render_cookie_banner(p)
      parts = []
      (parts << ((((((("<div class=\"govuk-cookie-banner" + Attributes.classes_if(p.get("classes"))) + "\" data-nosnippet role=\"region\" aria-label=\"") + Nunjucks.out(Nunjucks.default_truthy(p.get("ariaLabel"), "Cookie banner"))) + "\"") + Attributes.flag_if(" hidden", p.get("hidden"))) + Attributes.attributes(p.get("attributes"))) + ">\n"))
      Nunjucks.items(p.get("messages")).each do |message|
        (parts << (((((("  <div class=\"govuk-cookie-banner__message" + Attributes.classes_if(Nunjucks.get(message, "classes"))) + " govuk-width-container\"") + Attributes.attribute_if("role", Nunjucks.get(message, "role"))) + Attributes.attributes(Nunjucks.get(message, "attributes"))) + Attributes.flag_if(" hidden", Nunjucks.get(message, "hidden"))) + ">\n\n"))
        (parts << "    <div class=\"govuk-grid-row\">\n")
        (parts << "      <div class=\"govuk-grid-column-two-thirds\">\n")
        if (Nunjucks.truthy?(Nunjucks.get(message, "headingHtml")) || Nunjucks.truthy?(Nunjucks.get(message, "headingText")))
          (parts << "        <h2 class=\"govuk-cookie-banner__heading govuk-heading-m\">\n")
          (parts << (("          " + Attributes.content_indent(message, "headingHtml", "headingText", 10)) + "\n"))
          (parts << "        </h2>\n")
        end
        (parts << "        <div class=\"govuk-cookie-banner__content\">\n")
        html, text = [Nunjucks.get(message, "html"), Nunjucks.get(message, "text")]
        if Nunjucks.truthy?(html)
          (parts << (("          " + Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), 10, false)) + "\n"))
        elsif Nunjucks.truthy?(text)
          (parts << (("          <p class=\"govuk-body\">" + Nunjucks.out(text)) + "</p>\n"))
        end
        (parts << "        </div>\n      </div>\n    </div>\n\n")
        actions = Nunjucks.items(Nunjucks.get(message, "actions"))
        raw_actions = Nunjucks.get(message, "actions")
        if raw_actions.is_a?(Array)
          (parts << "    <div class=\"govuk-button-group\">\n")
          actions.each do |action|
            (parts << (("      " + Nunjucks.indent(Nunjucks.trim(_cookie_banner_action(action)), 6, false)) + "\n"))
          end
          (parts << "    </div>\n")
        end
        (parts << "\n  </div>\n")
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def _cookie_banner_action(action)
      href = Nunjucks.get(action, "href")
      if (!(Nunjucks.truthy?(href)) || (Nunjucks.str_value(Nunjucks.get(action, "type")) == "button"))
        return ComponentsButton.render_button(Params.new_params("text", Nunjucks.get(action, "text"), "type", Nunjucks.default_truthy(Nunjucks.get(action, "type"), "button"), "name", Nunjucks.get(action, "name"), "value", Nunjucks.get(action, "value"), "classes", Nunjucks.get(action, "classes"), "href", href, "attributes", Nunjucks.get(action, "attributes")))
      end
      return (((((((("<a class=\"govuk-link" + Attributes.classes_if(Nunjucks.get(action, "classes"))) + "\" href=\"") + Nunjucks.out(href)) + "\"") + Attributes.attributes(Nunjucks.get(action, "attributes"))) + ">") + Nunjucks.out(Nunjucks.get(action, "text"))) + "</a>")
    end
    
  end
end

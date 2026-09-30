# frozen_string_literal: true

# Auto-ported from Python for GOV.UK Frontend fixture parity.
# Source: govuk_components/rendering/components_button.py
module Govuk
  module ComponentsButton
    module_function
    
    START_ICON = "\n  <svg class=\"govuk-button__start-icon\" xmlns=\"http://www.w3.org/2000/svg\" width=\"17.5\" height=\"19\" viewBox=\"0 0 33 40\" aria-hidden=\"true\" focusable=\"false\">\n    <path fill=\"currentColor\" d=\"M0 0h13l20 20-20 20H0l20-20z\"/>\n  </svg>"
    
    EXIT_THIS_PAGE_DEFAULT_HTML = "  <span class=\"govuk-visually-hidden\">Emergency</span> Exit this page\n"
    
    def render_button(p)
      class_names = "govuk-button"
      classes = p.get("classes")
      if Nunjucks.truthy?(classes)
        class_names += (" " + Nunjucks.str_value(classes))
      end
      start_button = Nunjucks.truthy?(p.get("isStartButton"))
      if start_button
        class_names += " govuk-button--start"
      end
      common_attributes = ((((" class=\"" + Nunjucks.escape(class_names)) + "\" data-module=\"govuk-button\"") + Attributes.attributes(p.get("attributes"))) + Attributes.attribute_if("id", p.get("id")))
      html = p.get("html")
      text = Nunjucks.out(p.get("text"))
      if (Nunjucks.truthy?(html) && start_button)
        text = (("<span>" + Nunjucks.trim(Nunjucks.str_value(html))) + "</span>")
      elsif Nunjucks.truthy?(html)
        text = Nunjucks.trim(Nunjucks.str_value(html))
      end
      parts = []
      if Nunjucks.truthy?(p.get("href"))
        (parts << ((((("<a href=\"" + Nunjucks.out(p.get("href"))) + "\" role=\"button\" draggable=\"false\"") + common_attributes) + ">\n  ") + Nunjucks.indent(text, 2, false)))
      else
        (parts << ((((("<button type=\"" + Nunjucks.out(Nunjucks.default_truthy(p.get("type"), "submit"))) + "\"") + Attributes.attribute_if("value", p.get("value"))) + Attributes.attribute_if("name", p.get("name"))) + Attributes.flag_if(" disabled aria-disabled=\"true\"", p.get("disabled"))))
        prevent_double_click = p.get("preventDoubleClick")
        if !(Nunjucks.undefined?(prevent_double_click))
          (parts << ((" data-prevent-double-click=\"" + Nunjucks.out(prevent_double_click)) + "\""))
        end
        (parts << ((common_attributes + ">\n  ") + Nunjucks.indent(text, 2, false)))
      end
      if start_button
        (parts << START_ICON)
      end
      if Nunjucks.truthy?(p.get("href"))
        (parts << "\n</a>")
      else
        (parts << "\n</button>")
      end
      return parts.join("")
    end
    
    def render_exit_this_page(p)
      html = p.get("html")
      if (!(Nunjucks.truthy?(html)) && !(Nunjucks.truthy?(p.get("text"))))
        html = Safe.new(EXIT_THIS_PAGE_DEFAULT_HTML)
      end
      button = render_button(Params.new_params("html", html, "text", p.get("text"), "classes", "govuk-button--warning govuk-exit-this-page__button govuk-js-exit-this-page-button", "href", Nunjucks.default_truthy(p.get("redirectUrl"), "https://www.bbc.co.uk/weather"), "attributes", Params.new_params("rel", "nofollow noreferrer")))
      return (((((((((((("<div" + Attributes.attribute_if("id", p.get("id"))) + " class=\"govuk-exit-this-page") + Attributes.classes_if(p.get("classes"))) + "\" data-module=\"govuk-exit-this-page\"") + Attributes.attributes(p.get("attributes"))) + Attributes.attribute_if("data-i18n.activated", p.get("activatedText"))) + Attributes.attribute_if("data-i18n.timed-out", p.get("timedOutText"))) + Attributes.attribute_if("data-i18n.press-two-more-times", p.get("pressTwoMoreTimesText"))) + Attributes.attribute_if("data-i18n.press-one-more-time", p.get("pressOneMoreTimeText"))) + ">\n  ") + Nunjucks.indent(Nunjucks.trim(button), 2, false)) + "\n</div>")
    end
    
  end
end

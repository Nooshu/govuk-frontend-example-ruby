# frozen_string_literal: true

# Auto-ported from Python for GOV.UK Frontend fixture parity.
# Source: govuk_components/rendering/components_text.py
module Govuk
  module ComponentsText
    module_function
    
    def render_back_link(p)
      text = Nunjucks.out(Nunjucks.default_truthy(p.get("text"), "Back"))
      html = p.get("html")
      if Nunjucks.truthy?(html)
        text = Nunjucks.str_value(html)
      end
      return (((((((("<a href=\"" + Nunjucks.out(Nunjucks.default_truthy(p.get("href"), "\#"))) + "\" class=\"govuk-back-link") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">") + text) + "</a>")
    end
    
    def render_skip_link(p)
      return (((((((("<a href=\"" + Nunjucks.out(Nunjucks.default_truthy(p.get("href"), "\#content"))) + "\" class=\"govuk-skip-link") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + " data-module=\"govuk-skip-link\">") + Attributes.content(p, "html", "text")) + "</a>")
    end
    
    def render_hint(p)
      return (((((((("<div" + Attributes.attribute_if("id", p.get("id"))) + " class=\"govuk-hint") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n  ") + Attributes.content_indent(p, "html", "text", 2)) + "\n</div>")
    end
    
    def render_inset_text(p)
      return (((((((("<div" + Attributes.attribute_if("id", p.get("id"))) + " class=\"govuk-inset-text") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n  ") + Attributes.content_indent(p, "html", "text", 2)) + "\n</div>")
    end
    
    def render_tag(p)
      if p.nil?
        p = Params.new
      end
      return (((((("<strong class=\"govuk-tag" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n  ") + Attributes.content_indent(p, "html", "text", 2)) + "\n</strong>")
    end
    
    def render_warning_text(p)
      return ((((((((((((("<div class=\"govuk-warning-text" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n") + "  <span class=\"govuk-warning-text__icon\" aria-hidden=\"true\">!</span>\n") + "  <strong class=\"govuk-warning-text__text\">\n") + "    <span class=\"govuk-visually-hidden\">") + Nunjucks.out(Nunjucks.default_truthy(p.get("iconFallbackText"), "Warning"))) + "</span>\n") + "    ") + Attributes.content(p, "html", "text")) + "\n") + "  </strong>\n</div>")
    end
    
    def render_error_message(p)
      visually_hidden = Nunjucks.default(p.get("visuallyHiddenText"), "Error")
      message = Attributes.content_indent(p, "html", "text", 2)
      parts = []
      (parts << (((((("<p" + Attributes.attribute_if("id", p.get("id"))) + " class=\"govuk-error-message") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      if Nunjucks.truthy?(visually_hidden)
        (parts << (((("  <span class=\"govuk-visually-hidden\">" + Nunjucks.out(visually_hidden)) + ":</span> ") + message) + "\n"))
      else
        (parts << (("  " + message) + "\n"))
      end
      (parts << "</p>")
      return parts.join("")
    end
    
    def render_details(p)
      return (((((((((((((((((("<details" + Attributes.attribute_if("id", p.get("id"))) + " class=\"govuk-details") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + Attributes.flag_if(" open", p.get("open"))) + ">\n") + "  <summary class=\"govuk-details__summary\">\n") + "    <span class=\"govuk-details__summary-text\">\n") + "      ") + Attributes.content_indent(p, "summaryHtml", "summaryText", 6)) + "\n") + "    </span>\n  </summary>\n") + "  <div class=\"govuk-details__text\">\n") + "    ") + Attributes.content(p, "html", "text")) + "\n") + "  </div>\n</details>")
    end
    
    def render_label(p)
      if (!(Nunjucks.truthy?(p.get("html"))) && !(Nunjucks.truthy?(p.get("text"))))
        return ""
      end
      label = ((((((("<label class=\"govuk-label" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + Attributes.attribute_if("for", p.get("for"))) + ">\n  ") + Attributes.content_indent(p, "html", "text", 2)) + "\n</label>\n")
      if Nunjucks.truthy?(p.get("isPageHeading"))
        return (("<h1 class=\"govuk-label-wrapper\">\n  " + Nunjucks.indent(Nunjucks.trim(label), 2, false)) + "\n</h1>\n")
      end
      return (Nunjucks.trim(label) + "\n")
    end
    
    def render_panel(p)
      classes = p.get("classes")
      interruption = (Nunjucks.truthy?(classes) && Nunjucks.contains?("govuk-panel--interruption", classes))
      level = Nunjucks.heading(p.get("headingLevel"), "1")
      parts = []
      (parts << "<div class=\"govuk-panel")
      if !(interruption)
        (parts << " govuk-panel--confirmation")
      end
      (parts << (((Attributes.classes_if(classes) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      (parts << ((((((("  <h" + level) + " class=\"govuk-panel__title\">") + "\n    ") + Attributes.content(p, "titleHtml", "titleText")) + "\n  </h") + level) + ">\n"))
      if (Nunjucks.truthy?(p.get("html")) || Nunjucks.truthy?(p.get("text")))
        (parts << (("  <div class=\"govuk-panel__body\">\n    " + Attributes.content_indent(p, "html", "text", 4)) + "\n  </div>\n"))
      end
      actions = p.get("actions")
      if (interruption && Nunjucks.truthy?(actions))
        (parts << (((("  <div class=\"govuk-panel__actions" + Attributes.classes_if(Nunjucks.get(actions, "classes"))) + "\"") + Attributes.attributes(Nunjucks.get(actions, "attributes"))) + ">"))
        entries = Nunjucks.items(Nunjucks.get(actions, "items"))
        if (entries.length > 0)
          (parts << "<div class=\"govuk-button-group\">\n")
          entries.each do |action|
            (parts << (("      " + Nunjucks.indent(Nunjucks.trim(_panel_action(action)), 6, false)) + "\n"))
          end
          (parts << "    </div>")
        end
        (parts << "</div>\n")
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def _panel_action(action)
      href = Nunjucks.get(action, "href")
      if (!(Nunjucks.truthy?(href)) || (Nunjucks.str_value(Nunjucks.get(action, "type")) == "button"))
        return ComponentsButton.render_button(Params.new_params("text", Nunjucks.get(action, "text"), "type", Nunjucks.default_truthy(Nunjucks.get(action, "type"), "button"), "classes", ("govuk-button--inverse" + Nunjucks.concat_if(" ", Nunjucks.get(action, "classes"))), "href", href, "attributes", Nunjucks.get(action, "attributes")))
      end
      return (((((((("<a class=\"govuk-link govuk-link--inverse" + Attributes.classes_if(Nunjucks.get(action, "classes"))) + "\" href=\"") + Nunjucks.out(href)) + "\"") + Attributes.attributes(Nunjucks.get(action, "attributes"))) + ">") + Nunjucks.out(Nunjucks.get(action, "text"))) + "</a>")
    end
    
    def render_phase_banner(p)
      tag = p.get("tag")
      tag_html = render_tag(Params.new_params("text", Nunjucks.get(tag, "text"), "html", Nunjucks.get(tag, "html"), "classes", ("govuk-phase-banner__content__tag" + Nunjucks.concat_if(" ", Nunjucks.get(tag, "classes")))))
      return ((((((((((((("<div class=\"govuk-phase-banner govuk-width-container" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n") + "  <p class=\"govuk-phase-banner__content\">\n") + "    ") + Nunjucks.indent(Nunjucks.trim(tag_html), 4, false)) + "\n") + "    <span class=\"govuk-phase-banner__text\">\n") + "      ") + Attributes.content_indent(p, "html", "text", 6)) + "\n") + "    </span>\n  </p>\n</div>")
    end
    
    def render_feedback(p)
      level = Nunjucks.heading(p.get("headingLevel"), "2")
      parts = []
      (parts << (((("<div class=\"govuk-feedback govuk-width-container" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      (parts << "  <div class=\"govuk-grid-row\">\n")
      (parts << "    <div class=\"govuk-grid-column-two-thirds\">\n")
      (parts << ((((((("      <h" + level) + " class=\"govuk-feedback__title\">") + "\n        ") + Attributes.content(p, "titleHtml", "titleText")) + "\n      </h") + level) + ">\n"))
      html, text = [p.get("html"), p.get("text")]
      if (Nunjucks.truthy?(html) || Nunjucks.truthy?(text))
        (parts << "        <div class=\"govuk-feedback__body\">\n")
        if Nunjucks.truthy?(html)
          (parts << (("            " + Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), 4, false)) + "\n"))
        elsif Nunjucks.truthy?(text)
          (parts << "            <p class=\"govuk-body\">\n")
          (parts << (("              " + Nunjucks.escape(Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(text)), 6, false))) + "\n"))
          (parts << "            </p>\n")
        end
        (parts << "        </div>\n")
      end
      (parts << "    </div>\n  </div>\n</div>")
      return parts.join("")
    end
    
    def render_fieldset(p)
      parts = []
      (parts << (((((("<fieldset class=\"govuk-fieldset" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attribute_if("role", p.get("role"))) + Attributes.attribute_if("aria-describedby", p.get("describedBy"))) + Attributes.attributes(p.get("attributes"))) + ">\n"))
      legend = p.get("legend")
      if (Nunjucks.truthy?(Nunjucks.get(legend, "html")) || Nunjucks.truthy?(Nunjucks.get(legend, "text")))
        (parts << (("  <legend class=\"govuk-fieldset__legend" + Attributes.classes_if(Nunjucks.get(legend, "classes"))) + "\">\n"))
        if Nunjucks.truthy?(Nunjucks.get(legend, "isPageHeading"))
          (parts << "    <h1 class=\"govuk-fieldset__heading\">\n")
          (parts << (("      " + Attributes.content_indent(legend, "html", "text", 6)) + "\n"))
          (parts << "    </h1>\n")
        else
          (parts << (("    " + Attributes.content_indent(legend, "html", "text", 4)) + "\n"))
        end
        (parts << "  </legend>\n")
      end
      html = p.get("html")
      if Nunjucks.truthy?(html)
        (parts << (("  " + Nunjucks.str_value(html)) + "\n"))
      end
      (parts << "</fieldset>")
      return parts.join("")
    end
    
  end
end

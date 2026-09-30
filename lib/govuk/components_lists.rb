# frozen_string_literal: true

# Auto-ported from Python for GOV.UK Frontend fixture parity.
# Source: govuk_components/rendering/components_lists.py
module Govuk
  module ComponentsLists
    module_function
    
    def render_accordion(p)
      parts = []
      (parts << (((((((((("<div class=\"govuk-accordion" + Attributes.classes_if(p.get("classes"))) + "\" data-module=\"govuk-accordion\" id=\"") + Nunjucks.out(p.get("id"))) + "\"") + Attributes.i18n_attributes("hide-all-sections", p.get("hideAllSectionsText"), UNDEFINED)) + Attributes.i18n_attributes("hide-section", p.get("hideSectionText"), UNDEFINED)) + Attributes.i18n_attributes("hide-section-aria-label", p.get("hideSectionAriaLabelText"), UNDEFINED)) + Attributes.i18n_attributes("show-all-sections", p.get("showAllSectionsText"), UNDEFINED)) + Attributes.i18n_attributes("show-section", p.get("showSectionText"), UNDEFINED)) + Attributes.i18n_attributes("show-section-aria-label", p.get("showSectionAriaLabelText"), UNDEFINED)))
      remember = p.get("rememberExpanded")
      if !(Nunjucks.undefined?(remember))
        (parts << ((" data-remember-expanded=\"" + Nunjucks.escape(Nunjucks.str_value(remember))) + "\""))
      end
      (parts << (Attributes.attributes(p.get("attributes")) + ">\n"))
      Nunjucks.items(p.get("items")).each_with_index do |item, index|
        if !(Nunjucks.truthy?(item))
          next
        end
        (parts << _accordion_item(p, item, (index + 1)))
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def _accordion_item(p, item, index)
      level = Nunjucks.heading(p.get("headingLevel"), "2")
      id_ = Nunjucks.out(p.get("id"))
      position = index.to_s
      item_heading = Nunjucks.get(item, "heading")
      summary = Nunjucks.get(item, "summary")
      item_content = Nunjucks.get(item, "content")
      parts = []
      (parts << (("  <div class=\"govuk-accordion__section" + Attributes.flag_if(" govuk-accordion__section--expanded", Nunjucks.get(item, "expanded"))) + "\">\n"))
      (parts << "    <div class=\"govuk-accordion__section-header\">\n")
      (parts << (("      <h" + level) + " class=\"govuk-accordion__section-heading\">\n"))
      (parts << (((("        <span class=\"govuk-accordion__section-button\" id=\"" + id_) + "-heading-") + position) + "\">\n"))
      (parts << (("          " + Attributes.content_indent(item_heading, "html", "text", 8)) + "\n"))
      (parts << (("        </span>\n      </h" + level) + ">\n"))
      if (Nunjucks.truthy?(Nunjucks.get(summary, "html")) || Nunjucks.truthy?(Nunjucks.get(summary, "text")))
        (parts << (((("      <div class=\"govuk-accordion__section-summary govuk-body\" id=\"" + id_) + "-summary-") + position) + "\">\n"))
        (parts << (("        " + Attributes.content_indent(summary, "html", "text", 8)) + "\n"))
        (parts << "      </div>\n")
      end
      (parts << "    </div>\n")
      (parts << (((("    <div id=\"" + id_) + "-content-") + position) + "\" class=\"govuk-accordion__section-content\">\n"))
      html, text = [Nunjucks.get(item_content, "html"), Nunjucks.get(item_content, "text")]
      if Nunjucks.truthy?(html)
        (parts << (("      " + Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), 6, false)) + "\n"))
      elsif Nunjucks.truthy?(text)
        (parts << "      <p class=\"govuk-body\">\n")
        (parts << (("        " + Nunjucks.escape(Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(text)), 8, false))) + "\n"))
        (parts << "      </p>\n")
      end
      (parts << "    </div>\n  </div>\n")
      return parts.join("")
    end
    
    def render_error_summary(p)
      parts = []
      (parts << (("<div class=\"govuk-error-summary" + Attributes.classes_if(p.get("classes"))) + "\""))
      auto_focus = p.get("disableAutoFocus")
      if !(Nunjucks.undefined?(auto_focus))
        (parts << ((" data-disable-auto-focus=\"" + Nunjucks.out(auto_focus)) + "\""))
      end
      (parts << (Attributes.attributes(p.get("attributes")) + " data-module=\"govuk-error-summary\">"))
      (parts << "\n  <div role=\"alert\">\n")
      (parts << "    <h2 class=\"govuk-error-summary__title\">\n")
      (parts << (("      " + Attributes.content_indent(p, "titleHtml", "titleText", 6)) + "\n"))
      (parts << "    </h2>\n")
      (parts << "    <div class=\"govuk-error-summary__body\">\n")
      if (Nunjucks.truthy?(p.get("descriptionHtml")) || Nunjucks.truthy?(p.get("descriptionText")))
        (parts << (("      <p>\n        " + Attributes.content_indent(p, "descriptionHtml", "descriptionText", 8)) + "\n      </p>\n"))
      end
      error_list = Nunjucks.items(p.get("errorList"))
      if (error_list.length > 0)
        (parts << "        <ul class=\"govuk-list govuk-error-summary__list\">\n")
        error_list.each do |item|
          (parts << "          <li>\n")
          href = Nunjucks.get(item, "href")
          if Nunjucks.truthy?(href)
            (parts << (((((("            <a href=\"" + Nunjucks.out(href)) + "\"") + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + Attributes.content_indent(item, "html", "text", 12)) + "</a>\n"))
          else
            (parts << (("            " + Attributes.content_indent(item, "html", "text", 10)) + "\n"))
          end
          (parts << "          </li>\n")
        end
        (parts << "        </ul>\n")
      end
      (parts << "    </div>\n  </div>\n</div>")
      return parts.join("")
    end
    
    def render_notification_banner(p)
      success = (Nunjucks.str_value(p.get("type")) == "success")
      type_class = ""
      if success
        type_class = (" govuk-notification-banner--" + Nunjucks.escape(Nunjucks.str_value(p.get("type"))))
      end
      role = "region"
      if Nunjucks.truthy?(p.get("role"))
        role = Nunjucks.str_value(p.get("role"))
      elsif success
        role = "alert"
      end
      if Nunjucks.truthy?(p.get("titleHtml"))
        title = Nunjucks.str_value(p.get("titleHtml"))
      elsif Nunjucks.truthy?(p.get("titleText"))
        title = Nunjucks.out(p.get("titleText"))
      elsif success
        title = "Success"
      else
        title = "Important"
      end
      title_id = Nunjucks.out(Nunjucks.default_truthy(p.get("titleId"), "govuk-notification-banner-title"))
      level = Nunjucks.out(Nunjucks.default_truthy(p.get("titleHeadingLevel"), "2"))
      parts = []
      (parts << ((((((("<div class=\"govuk-notification-banner" + type_class) + Attributes.classes_if(p.get("classes"))) + "\" role=\"") + Nunjucks.escape(role)) + "\" aria-labelledby=\"") + title_id) + "\" data-module=\"govuk-notification-banner\""))
      auto_focus = p.get("disableAutoFocus")
      if !(Nunjucks.undefined?(auto_focus))
        (parts << ((" data-disable-auto-focus=\"" + Nunjucks.out(auto_focus)) + "\""))
      end
      (parts << (Attributes.attributes(p.get("attributes")) + ">\n"))
      (parts << "  <div class=\"govuk-notification-banner__header\">\n")
      (parts << (((("    <h" + level) + " class=\"govuk-notification-banner__title\" id=\"") + title_id) + "\">\n"))
      (parts << (((("      " + title) + "\n    </h") + level) + ">\n  </div>\n"))
      (parts << "  <div class=\"govuk-notification-banner__content\">\n")
      html, text = [p.get("html"), p.get("text")]
      if Nunjucks.truthy?(html)
        (parts << (("    " + Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), 4, false)) + "\n"))
      elsif Nunjucks.truthy?(text)
        (parts << "    <p class=\"govuk-notification-banner__heading\">\n")
        (parts << (("      " + Nunjucks.escape(Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(text)), 6, false))) + "\n"))
        (parts << "    </p>\n")
      end
      (parts << "  </div>\n</div>")
      return parts.join("")
    end
    
    def render_summary_list(p)
      card = p.get("card")
      card_title = Nunjucks.get(card, "title")
      any_row_has_actions = false
      Nunjucks.items(p.get("rows")).each do |row|
        if (Nunjucks.length(Nunjucks.get(row, "actions", "items")) > 0)
          any_row_has_actions = true
        end
      end
      list_parts = []
      (list_parts << (((("<dl class=\"govuk-summary-list" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      Nunjucks.items(p.get("rows")).each do |row|
        if !(Nunjucks.truthy?(row))
          next
        end
        key, value, actions = [Nunjucks.get(row, "key"), Nunjucks.get(row, "value"), Nunjucks.get(row, "actions")]
        (list_parts << ((("  <div class=\"govuk-summary-list__row" + Attributes.flag_if(" govuk-summary-list__row--no-actions", (any_row_has_actions && !(Nunjucks.truthy?(Nunjucks.get(actions, "items")))))) + Attributes.classes_if(Nunjucks.get(row, "classes"))) + "\">\n"))
        (list_parts << (((("    <dt class=\"govuk-summary-list__key" + Attributes.classes_if(Nunjucks.get(key, "classes"))) + "\">\n      ") + Attributes.content_indent(key, "html", "text", 6)) + "\n    </dt>\n"))
        (list_parts << (((("    <dd class=\"govuk-summary-list__value" + Attributes.classes_if(Nunjucks.get(value, "classes"))) + "\">\n      ") + Attributes.content_indent(value, "html", "text", 6)) + "\n    </dd>\n"))
        entries = Nunjucks.items(Nunjucks.get(actions, "items"))
        if (entries.length > 0)
          (list_parts << (("    <dd class=\"govuk-summary-list__actions" + Attributes.classes_if(Nunjucks.get(actions, "classes"))) + "\">\n"))
          if (entries.length == 1)
            (list_parts << (Nunjucks.indent(Nunjucks.trim(_summary_action_link(entries[0], card_title)), 6, true) + "\n"))
          else
            (list_parts << "      <ul class=\"govuk-summary-list__actions-list\">\n")
            entries.each do |action|
              (list_parts << "        <li class=\"govuk-summary-list__actions-list-item\">\n")
              (list_parts << (("          " + Nunjucks.indent(Nunjucks.trim(_summary_action_link(action, card_title)), 8, false)) + "\n"))
              (list_parts << "        </li>\n")
            end
            (list_parts << "      </ul>\n")
          end
          (list_parts << "    </dd>\n")
        end
        (list_parts << "  </div>\n")
      end
      (list_parts << "</dl>")
      if Nunjucks.truthy?(card)
        return _summary_card(card, Nunjucks.indent(Nunjucks.trim(list_parts.join("")), 4, false))
      end
      return Nunjucks.trim(list_parts.join(""))
    end
    
    def _summary_action_link(action, card_title)
      parts = []
      (parts << (((((("  <a class=\"govuk-link" + Attributes.classes_if(Nunjucks.get(action, "classes"))) + "\" href=\"") + Nunjucks.out(Nunjucks.get(action, "href"))) + "\"") + Attributes.attributes(Nunjucks.get(action, "attributes"))) + ">"))
      html = Nunjucks.get(action, "html")
      if Nunjucks.truthy?(html)
        (parts << Nunjucks.indent(Nunjucks.str_value(html), 4, false))
      else
        (parts << Nunjucks.out(Nunjucks.get(action, "text")))
      end
      visually_hidden = Nunjucks.get(action, "visuallyHiddenText")
      if (Nunjucks.truthy?(visually_hidden) || Nunjucks.truthy?(card_title))
        (parts << "<span class=\"govuk-visually-hidden\">")
        if Nunjucks.truthy?(visually_hidden)
          (parts << (" " + Nunjucks.out(visually_hidden)))
        end
        if Nunjucks.truthy?(card_title)
          title = Nunjucks.out(Nunjucks.get(card_title, "text"))
          html = Nunjucks.get(card_title, "html")
          if Nunjucks.truthy?(html)
            title = Nunjucks.indent(Nunjucks.str_value(html), 6, false)
          end
          (parts << ((" (" + title) + ")"))
        end
        (parts << "</span>")
      end
      (parts << "</a>\n")
      return parts.join("")
    end
    
    def _summary_card(card, body)
      title = Nunjucks.get(card, "title")
      level = Nunjucks.heading(Nunjucks.get(title, "headingLevel"), "2")
      actions = Nunjucks.get(card, "actions")
      parts = []
      (parts << (((("<div class=\"govuk-summary-card" + Attributes.classes_if(Nunjucks.get(card, "classes"))) + "\"") + Attributes.attributes(Nunjucks.get(card, "attributes"))) + ">\n"))
      (parts << "  <div class=\"govuk-summary-card__title-wrapper\">\n")
      if Nunjucks.truthy?(title)
        (parts << (((((((("    <h" + level) + " class=\"govuk-summary-card__title") + Attributes.classes_if(Nunjucks.get(title, "classes"))) + "\">\n      ") + Attributes.content_indent(title, "html", "text", 6)) + "\n    </h") + level) + ">\n"))
      end
      entries = Nunjucks.items(Nunjucks.get(actions, "items"))
      if (entries.length > 0)
        if (entries.length == 1)
          (parts << (("    <div class=\"govuk-summary-card__actions" + Attributes.classes_if(Nunjucks.get(actions, "classes"))) + "\">\n"))
          (parts << (("      " + Nunjucks.indent(Nunjucks.trim(_summary_action_link(entries[0], title)), 4, false)) + "\n"))
          (parts << "    </div>\n")
        else
          (parts << (("    <ul class=\"govuk-summary-card__actions" + Attributes.classes_if(Nunjucks.get(actions, "classes"))) + "\">\n"))
          entries.each do |action|
            (parts << "      <li class=\"govuk-summary-card__action\">\n")
            (parts << (("        " + Nunjucks.indent(Nunjucks.trim(_summary_action_link(action, title)), 8, false)) + "\n"))
            (parts << "      </li>\n")
          end
          (parts << "    </ul>\n")
        end
      end
      (parts << "  </div>\n\n")
      (parts << (("  <div class=\"govuk-summary-card__content\">\n    " + body) + "\n  </div>\n</div>\n"))
      return parts.join("")
    end
    
    def render_table(p)
      parts = []
      (parts << (((("<table class=\"govuk-table" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      caption = p.get("caption")
      if Nunjucks.truthy?(caption)
        (parts << (((("  <caption class=\"govuk-table__caption" + Attributes.classes_if(p.get("captionClasses"))) + "\">") + Nunjucks.out(caption)) + "</caption>\n"))
      end
      head = Nunjucks.items(p.get("head"))
      if Nunjucks.truthy?(p.get("head"))
        (parts << "  <thead class=\"govuk-table__head\">\n")
        (parts << "    <tr class=\"govuk-table__row\">\n")
        head.each do |item|
          (parts << ((((((((("      <th scope=\"col\" class=\"govuk-table__header" + _format_class("govuk-table__header--", Nunjucks.get(item, "format"))) + Attributes.classes_if(Nunjucks.get(item, "classes"))) + "\"") + Attributes.attribute_if("colspan", Nunjucks.get(item, "colspan"))) + Attributes.attribute_if("rowspan", Nunjucks.get(item, "rowspan"))) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + Attributes.content(item, "html", "text")) + "</th>\n"))
        end
        (parts << "    </tr>\n  </thead>\n")
      end
      (parts << "  <tbody class=\"govuk-table__body\">\n")
      Nunjucks.items(p.get("rows")).each do |row|
        if !(Nunjucks.truthy?(row))
          next
        end
        (parts << "    <tr class=\"govuk-table__row\">\n")
        Nunjucks.items(row).each_with_index do |cell, index|
          common = ((Attributes.attribute_if("colspan", Nunjucks.get(cell, "colspan")) + Attributes.attribute_if("rowspan", Nunjucks.get(cell, "rowspan"))) + Attributes.attributes(Nunjucks.get(cell, "attributes")))
          if ((index == 0) && Nunjucks.truthy?(p.get("firstCellIsHeader")))
            (parts << (((((("      <th scope=\"row\" class=\"govuk-table__header" + Attributes.classes_if(Nunjucks.get(cell, "classes"))) + "\"") + common) + ">") + Attributes.content(cell, "html", "text")) + "</th>\n"))
          else
            (parts << ((((((("      <td class=\"govuk-table__cell" + _format_class("govuk-table__cell--", Nunjucks.get(cell, "format"))) + Attributes.classes_if(Nunjucks.get(cell, "classes"))) + "\"") + common) + ">") + Attributes.content(cell, "html", "text")) + "</td>\n"))
          end
        end
        (parts << "    </tr>\n")
      end
      (parts << "  </tbody>\n</table>")
      return parts.join("")
    end
    
    def _format_class(prefix, format_)
      if !(Nunjucks.truthy?(format_))
        return ""
      end
      return ((" " + prefix) + Nunjucks.out(format_))
    end
    
    def render_tabs(p)
      id_prefix = ""
      prefix = p.get("idPrefix")
      if Nunjucks.truthy?(prefix)
        id_prefix = Nunjucks.str_value(prefix)
      end
      parts = []
      (parts << (((((("<div" + Attributes.attribute_if("id", p.get("id"))) + " class=\"govuk-tabs") + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + " data-module=\"govuk-tabs\">\n"))
      (parts << (("  <h2 class=\"govuk-tabs__title\">\n    " + Nunjucks.out(Nunjucks.default(p.get("title"), "Contents"))) + "\n  </h2>\n"))
      entries = Nunjucks.items(p.get("items"))
      if (entries.length > 0)
        (parts << "  <ul class=\"govuk-tabs__list\">\n")
        entries.each_with_index do |item, index|
          if !(Nunjucks.truthy?(item))
            next
          end
          (parts << (Nunjucks.indent(Nunjucks.trim(_tab_list_item(item, (index + 1), id_prefix)), 4, true) + "\n"))
        end
        (parts << "  </ul>\n")
        entries.each_with_index do |item, index|
          if !(Nunjucks.truthy?(item))
            next
          end
          (parts << (Nunjucks.indent(Nunjucks.trim(_tab_panel(item, (index + 1), id_prefix)), 2, true) + "\n"))
        end
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def _tab_panel_id(item, index, id_prefix)
      id_ = Nunjucks.get(item, "id")
      if Nunjucks.truthy?(id_)
        return Nunjucks.str_value(id_)
      end
      return ((id_prefix + "-") + index.to_s)
    end
    
    def _tab_list_item(item, index, id_prefix)
      return ((((((((("<li class=\"govuk-tabs__list-item" + Attributes.flag_if(" govuk-tabs__list-item--selected", (index == 1))) + "\">\n") + "  <a class=\"govuk-tabs__tab\" href=\"\#") + Nunjucks.escape(_tab_panel_id(item, index, id_prefix))) + "\"") + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">\n    ") + Nunjucks.out(Nunjucks.get(item, "label"))) + "\n  </a>\n</li>\n")
    end
    
    def _tab_panel(item, index, id_prefix)
      panel = Nunjucks.get(item, "panel")
      parts = []
      (parts << (((((("<div class=\"govuk-tabs__panel" + Attributes.flag_if(" govuk-tabs__panel--hidden", (index > 1))) + "\" id=\"") + Nunjucks.escape(_tab_panel_id(item, index, id_prefix))) + "\"") + Attributes.attributes(Nunjucks.get(panel, "attributes"))) + ">\n"))
      html, text = [Nunjucks.get(panel, "html"), Nunjucks.get(panel, "text")]
      if Nunjucks.truthy?(html)
        (parts << (("  " + Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), 2, false)) + "\n"))
      elsif Nunjucks.truthy?(text)
        (parts << (("  <p class=\"govuk-body\">" + Nunjucks.out(text)) + "</p>\n"))
      end
      (parts << "</div>\n")
      return parts.join("")
    end
    
    def render_task_list(p)
      id_prefix = "task-list"
      prefix = p.get("idPrefix")
      if Nunjucks.truthy?(prefix)
        id_prefix = Nunjucks.str_value(prefix)
      end
      parts = []
      (parts << (((("<ul class=\"govuk-task-list" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + ">\n"))
      Nunjucks.items(p.get("items")).each_with_index do |item, index|
        if Nunjucks.truthy?(item)
          (parts << (_task_list_item(item, (index + 1), id_prefix) + "\n"))
        else
          (parts << "\n")
        end
      end
      (parts << "</ul>")
      return parts.join("")
    end
    
    def _task_list_item(item, index, id_prefix)
      position = index.to_s
      hint_id = (((id_prefix + "-") + position) + "-hint")
      status_id = (((id_prefix + "-") + position) + "-status")
      title = Nunjucks.get(item, "title")
      hint = Nunjucks.get(item, "hint")
      status = Nunjucks.get(item, "status")
      parts = []
      (parts << ((("  <li class=\"govuk-task-list__item" + Attributes.flag_if(" govuk-task-list__item--with-link", Nunjucks.get(item, "href"))) + Attributes.classes_if(Nunjucks.get(item, "classes"))) + "\">\n"))
      (parts << "    <div class=\"govuk-task-list__name-and-hint\">\n")
      href = Nunjucks.get(item, "href")
      if Nunjucks.truthy?(href)
        described_by = status_id
        if Nunjucks.truthy?(hint)
          described_by = ((hint_id + " ") + status_id)
        end
        (parts << (((((("      <a class=\"govuk-link govuk-task-list__link" + Attributes.classes_if(Nunjucks.get(title, "classes"))) + "\" href=\"") + Nunjucks.out(href)) + "\" aria-describedby=\"") + Nunjucks.escape(described_by)) + "\">\n"))
        (parts << (("        " + Attributes.content_indent(title, "html", "text", 8)) + "\n"))
        (parts << "      </a>\n")
      else
        (parts << (("      <div" + Attributes.attribute_if("class", Nunjucks.get(title, "classes"))) + ">\n"))
        (parts << (("        " + Attributes.content_indent(title, "html", "text", 8)) + "\n"))
        (parts << "      </div>\n")
      end
      if Nunjucks.truthy?(hint)
        (parts << (("      <div id=\"" + Nunjucks.escape(hint_id)) + "\" class=\"govuk-task-list__hint\">\n"))
        (parts << (("        " + Attributes.content_indent(hint, "html", "text", 8)) + "\n"))
        (parts << "      </div>\n")
      end
      (parts << "    </div>\n")
      (parts << (((("    <div class=\"govuk-task-list__status" + Attributes.classes_if(Nunjucks.get(status, "classes"))) + "\" id=\"") + Nunjucks.escape(status_id)) + "\">\n"))
      tag = Nunjucks.get(status, "tag")
      if Nunjucks.truthy?(tag)
        tag_params = (tag.is_a?(Params) ? tag : nil)
        (parts << (("      " + Nunjucks.indent(Nunjucks.trim(ComponentsText.render_tag(tag_params)), 6, false)) + "\n"))
      else
        (parts << (("      " + Attributes.content_indent(status, "html", "text", 6)) + "\n"))
      end
      (parts << "    </div>\n  </li>")
      return parts.join("")
    end
    
  end
end

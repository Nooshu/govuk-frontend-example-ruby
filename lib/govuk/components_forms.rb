# frozen_string_literal: true

# Auto-ported from Python for GOV.UK Frontend fixture parity.
# Source: govuk_components/rendering/components_forms.py
module Govuk
  module ComponentsForms
    module_function
    
    def form_group_open(p)
      form_group = p.get("formGroup")
      return ((((("<div class=\"govuk-form-group" + Attributes.flag_if(" govuk-form-group--error", p.get("errorMessage"))) + Attributes.classes_if(Nunjucks.get(form_group, "classes"))) + "\"") + Attributes.attributes(Nunjucks.get(form_group, "attributes"))) + ">\n")
    end
    
    def described_by_append(described_by, id_)
      if (described_by != "")
        return ((described_by + " ") + id_)
      end
      return id_
    end
    
    def hint_block(p, id_, described_by, width)
      hint = p.get("hint")
      if !(Nunjucks.truthy?(hint))
        return ["", described_by]
      end
      hint_id = (id_ + "-hint")
      described_by = described_by_append(described_by, hint_id)
      html = ComponentsText.render_hint(Params.new_params("id", hint_id, "classes", Nunjucks.get(hint, "classes"), "attributes", Nunjucks.get(hint, "attributes"), "html", Nunjucks.get(hint, "html"), "text", Nunjucks.get(hint, "text")))
      return [(((" " * width) + Nunjucks.indent(Nunjucks.trim(html), width, false)) + "\n"), described_by]
    end
    
    def error_block(p, id_, described_by, width)
      message = p.get("errorMessage")
      if !(Nunjucks.truthy?(message))
        return ["", described_by]
      end
      error_id = (id_ + "-error")
      described_by = described_by_append(described_by, error_id)
      html = ComponentsText.render_error_message(Params.new_params("id", error_id, "classes", Nunjucks.get(message, "classes"), "attributes", Nunjucks.get(message, "attributes"), "html", Nunjucks.get(message, "html"), "text", Nunjucks.get(message, "text"), "visuallyHiddenText", Nunjucks.get(message, "visuallyHiddenText")))
      return [(((" " * width) + Nunjucks.indent(Nunjucks.trim(html), width, false)) + "\n"), described_by]
    end
    
    def label_block(p, id_, width)
      label = p.get("label")
      html = ComponentsText.render_label(Params.new_params("html", Nunjucks.get(label, "html"), "text", Nunjucks.get(label, "text"), "classes", Nunjucks.get(label, "classes"), "isPageHeading", Nunjucks.get(label, "isPageHeading"), "attributes", Nunjucks.get(label, "attributes"), "for", id_))
      return (((" " * width) + Nunjucks.indent(Nunjucks.trim(html), width, false)) + "\n")
    end
    
    def slot_content(slot, width, indent_first)
      html = Nunjucks.get(slot, "html")
      if Nunjucks.truthy?(html)
        return Nunjucks.indent(Nunjucks.trim(Nunjucks.str_value(html)), width, indent_first)
      end
      return Nunjucks.out(Nunjucks.get(slot, "text"))
    end
    
    def component_id(p)
      id_ = p.get("id")
      if Nunjucks.truthy?(id_)
        return id_
      end
      return p.get("name")
    end
    
    def render_input(p)
      class_names = "govuk-input"
      classes = p.get("classes")
      if Nunjucks.truthy?(classes)
        class_names += (" " + Nunjucks.str_value(classes))
      end
      if Nunjucks.truthy?(p.get("errorMessage"))
        class_names += " govuk-input--error"
      end
      id_ = component_id(p)
      described_by = ""
      supplied = p.get("describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      form_group = p.get("formGroup")
      prefix, suffix = [p.get("prefix"), p.get("suffix")]
      before_input, after_input = [Nunjucks.get(form_group, "beforeInput"), Nunjucks.get(form_group, "afterInput")]
      has_prefix = (Nunjucks.truthy?(prefix) && (Nunjucks.truthy?(Nunjucks.get(prefix, "text")) || Nunjucks.truthy?(Nunjucks.get(prefix, "html"))))
      has_suffix = (Nunjucks.truthy?(suffix) && (Nunjucks.truthy?(Nunjucks.get(suffix, "text")) || Nunjucks.truthy?(Nunjucks.get(suffix, "html"))))
      has_before = (Nunjucks.truthy?(before_input) && (Nunjucks.truthy?(Nunjucks.get(before_input, "text")) || Nunjucks.truthy?(Nunjucks.get(before_input, "html"))))
      has_after = (Nunjucks.truthy?(after_input) && (Nunjucks.truthy?(Nunjucks.get(after_input, "text")) || Nunjucks.truthy?(Nunjucks.get(after_input, "html"))))
      parts = []
      (parts << form_group_open(p))
      (parts << label_block(p, id_, 2))
      hint, described_by = hint_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << error_message)
      element = input_element(p, class_names, id_, described_by)
      if (has_prefix || has_suffix || has_before || has_after)
        wrapper = p.get("inputWrapper")
        (parts << (((("  <div class=\"govuk-input__wrapper" + Attributes.classes_if(Nunjucks.get(wrapper, "classes"))) + "\"") + Attributes.attributes(Nunjucks.get(wrapper, "attributes"))) + ">\n"))
        if has_before
          (parts << (slot_content(before_input, 4, true) + "\n"))
        end
        if has_prefix
          (parts << (Nunjucks.indent(_affix_item(prefix, "prefix"), 2, true) + "\n"))
        end
        (parts << (("    " + element) + "\n"))
        if has_suffix
          (parts << (Nunjucks.indent(_affix_item(suffix, "suffix"), 2, true) + "\n"))
        end
        if has_after
          (parts << (slot_content(after_input, 4, true) + "\n"))
        end
        (parts << "  </div>\n")
      else
        (parts << (("  " + element) + "\n"))
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def input_element(p, class_names, id_, described_by)
      spellcheck = false
      flag = p.get("spellcheck")
      if (flag == true || flag == false)
        spellcheck = (flag ? "true" : "false")
      end
      aria_described_by = UNDEFINED
      if (described_by != "")
        aria_described_by = described_by
      end
      attributes = Params.new_params("class", class_names, "id", id_, "name", p.get("name"), "type", Nunjucks.default_truthy(p.get("type"), "text"), "spellcheck", Params.new_params("value", spellcheck, "optional", true), "value", Params.new_params("value", p.get("value"), "optional", true), "disabled", Params.new_params("value", p.get("disabled"), "optional", true), "aria-describedby", Params.new_params("value", aria_described_by, "optional", true), "autocomplete", Params.new_params("value", p.get("autocomplete"), "optional", true), "autocapitalize", Params.new_params("value", p.get("autocapitalize"), "optional", true), "pattern", Params.new_params("value", p.get("pattern"), "optional", true), "inputmode", Params.new_params("value", p.get("inputmode"), "optional", true))
      return ((("<input" + Attributes.attributes(attributes)) + Attributes.attributes(p.get("attributes"))) + ">")
    end
    
    def _affix_item(affix, kind)
      return ((((((("  <div class=\"govuk-input__" + kind) + Attributes.classes_if(Nunjucks.get(affix, "classes"))) + "\" aria-hidden=\"true\"") + Attributes.attributes(Nunjucks.get(affix, "attributes"))) + ">") + Attributes.content_indent(affix, "html", "text", 4)) + "</div>")
    end
    
    def render_textarea(p)
      id_ = component_id(p)
      described_by = ""
      supplied = p.get("describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      form_group = p.get("formGroup")
      parts = []
      (parts << form_group_open(p))
      (parts << label_block(p, id_, 2))
      hint, described_by = hint_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << error_message)
      before = Nunjucks.get(form_group, "beforeInput")
      if Nunjucks.truthy?(before)
        (parts << (("  " + slot_content(before, 2, false)) + "\n"))
      end
      spellcheck = ""
      flag = p.get("spellcheck")
      if (flag == true || flag == false)
        spellcheck = ((" spellcheck=\"" + (flag ? "true" : "false")) + "\"")
      end
      (parts << ((((((((((((((((("  <textarea class=\"govuk-textarea" + Attributes.flag_if(" govuk-textarea--error", p.get("errorMessage"))) + Attributes.classes_if(p.get("classes"))) + "\" id=\"") + Nunjucks.out(id_)) + "\" name=\"") + Nunjucks.out(p.get("name"))) + "\" rows=\"") + Nunjucks.out(Nunjucks.default_truthy(p.get("rows"), "5"))) + "\"") + spellcheck) + Attributes.flag_if(" disabled", p.get("disabled"))) + Attributes.attribute_if("aria-describedby", described_by)) + Attributes.attribute_if("autocomplete", p.get("autocomplete"))) + Attributes.attributes(p.get("attributes"))) + ">") + Nunjucks.out(p.get("value"))) + "</textarea>\n"))
      after = Nunjucks.get(form_group, "afterInput")
      if Nunjucks.truthy?(after)
        (parts << (("  " + slot_content(after, 2, false)) + "\n"))
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def render_select(p)
      id_ = component_id(p)
      described_by = ""
      supplied = p.get("describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      form_group = p.get("formGroup")
      parts = []
      (parts << form_group_open(p))
      (parts << label_block(p, id_, 2))
      hint, described_by = hint_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << error_message)
      before = Nunjucks.get(form_group, "beforeInput")
      if Nunjucks.truthy?(before)
        (parts << (("  " + slot_content(before, 2, false)) + "\n"))
      end
      (parts << ((((((((((("  <select class=\"govuk-select" + Attributes.classes_if(p.get("classes"))) + Attributes.flag_if(" govuk-select--error", p.get("errorMessage"))) + "\" id=\"") + Nunjucks.out(id_)) + "\" name=\"") + Nunjucks.out(p.get("name"))) + "\"") + Attributes.flag_if(" disabled", p.get("disabled"))) + Attributes.attribute_if("aria-describedby", described_by)) + Attributes.attributes(p.get("attributes"))) + ">\n"))
      selected = p.get("value")
      Nunjucks.items(p.get("items")).each do |item|
        if !(Nunjucks.truthy?(item))
          next
        end
        value = Nunjucks.get(item, "value")
        effective = Nunjucks.default(value, Nunjucks.get(item, "text"))
        is_selected = Nunjucks.truthy?(Nunjucks.get(item, "selected"))
        if (!(is_selected) && Nunjucks.truthy?(selected))
          is_selected = (Nunjucks.loose_eq(effective, selected) && !(Nunjucks.loose_eq(Nunjucks.get(item, "selected"), false)))
        end
        (parts << "    <option")
        if !(Nunjucks.undefined?(value))
          (parts << ((" value=\"" + Nunjucks.out(value)) + "\""))
        end
        (parts << (((((Attributes.flag_if(" selected", is_selected) + Attributes.flag_if(" disabled", Nunjucks.get(item, "disabled"))) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">") + Nunjucks.out(Nunjucks.get(item, "text"))) + "</option>\n"))
      end
      (parts << "  </select>\n")
      after = Nunjucks.get(form_group, "afterInput")
      if Nunjucks.truthy?(after)
        (parts << (("  " + slot_content(after, 2, false)) + "\n"))
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def render_file_upload(p)
      id_ = component_id(p)
      described_by = ""
      supplied = p.get("describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      form_group = p.get("formGroup")
      parts = []
      (parts << form_group_open(p))
      (parts << label_block(p, id_, 2))
      hint, described_by = hint_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(id_), described_by, 2)
      (parts << error_message)
      before = Nunjucks.get(form_group, "beforeInput")
      if Nunjucks.truthy?(before)
        (parts << (("  " + slot_content(before, 2, false)) + "\n"))
      end
      javascript = Nunjucks.truthy?(p.get("javascript"))
      if javascript
        (parts << (((((((((("  <div\n    class=\"govuk-file-upload-wrapper" + Attributes.classes_if(p.get("wrapperClasses"))) + "\"\n    data-module=\"govuk-file-upload\"") + Attributes.i18n_attributes("choose-files-button", p.get("chooseFilesButtonText"), UNDEFINED)) + Attributes.i18n_attributes("no-file-chosen", p.get("noFileChosenText"), UNDEFINED)) + Attributes.i18n_attributes("multiple-files-chosen", UNDEFINED, p.get("multipleFilesChosenText"))) + Attributes.i18n_attributes("drop-instruction", p.get("dropInstructionText"), UNDEFINED)) + Attributes.i18n_attributes("entered-drop-zone", p.get("enteredDropZoneText"), UNDEFINED)) + Attributes.i18n_attributes("left-drop-zone", p.get("leftDropZoneText"), UNDEFINED)) + Attributes.attributes(p.get("wrapperAttributes"))) + "\n  >\n"))
      end
      (parts << (((((((((((("  <input class=\"govuk-file-upload" + Attributes.classes_if(p.get("classes"))) + Attributes.flag_if(" govuk-file-upload--error", p.get("errorMessage"))) + "\" id=\"") + Nunjucks.out(id_)) + "\" name=\"") + Nunjucks.out(p.get("name"))) + "\" type=\"file\"") + Attributes.flag_if(" disabled", p.get("disabled"))) + Attributes.flag_if(" multiple", p.get("multiple"))) + Attributes.attribute_if("aria-describedby", described_by)) + Attributes.attributes(p.get("attributes"))) + ">\n"))
      if javascript
        (parts << "  </div>\n")
      end
      after = Nunjucks.get(form_group, "afterInput")
      if Nunjucks.truthy?(after)
        (parts << (("  " + slot_content(after, 2, false)) + "\n"))
      end
      (parts << "</div>")
      return parts.join("")
    end
    
    def render_character_count(p)
      maxwords, maxlength = [p.get("maxwords"), p.get("maxlength")]
      has_no_limit = (!(Nunjucks.truthy?(maxwords)) && !(Nunjucks.truthy?(maxlength)))
      id_ = component_id(p)
      description_no_limit = UNDEFINED
      if !(has_no_limit)
        limit = maxlength
        if Nunjucks.truthy?(maxwords)
          limit = maxwords
        end
        unit = "characters"
        if Nunjucks.truthy?(maxwords)
          unit = "words"
        end
        description = ("You can enter up to %{count} " + unit)
        supplied = p.get("textareaDescriptionText")
        if Nunjucks.truthy?(supplied)
          description = Nunjucks.str_value(supplied)
        end
        description_no_limit = description.gsub("%{count}", Nunjucks.str_value(limit))
      end
      count_message = p.get("countMessage")
      count_message_html = (Nunjucks.trim(ComponentsText.render_hint(Params.new_params("text", description_no_limit, "id", (Nunjucks.str_value(id_) + "-info"), "classes", ("govuk-character-count__message" + Nunjucks.concat_if(" ", Nunjucks.get(count_message, "classes")))))) + "\n")
      form_group = p.get("formGroup")
      after = Nunjucks.get(form_group, "afterInput")
      if Nunjucks.truthy?(after)
        html = Nunjucks.get(after, "html")
        if Nunjucks.truthy?(html)
          count_message_html += (Nunjucks.trim(Nunjucks.str_value(html)) + "\n")
        else
          count_message_html += (Nunjucks.out(Nunjucks.get(after, "text")) + "\n")
        end
      end
      attributes_html = Attributes.attributes(Params.new_params("data-module", "govuk-character-count", "data-maxlength", Params.new_params("value", maxlength, "optional", true), "data-threshold", Params.new_params("value", p.get("threshold"), "optional", true), "data-maxwords", Params.new_params("value", maxwords, "optional", true)))
      description = p.get("textareaDescriptionText")
      if (has_no_limit && Nunjucks.truthy?(description))
        attributes_html += Attributes.i18n_attributes("textarea-description", UNDEFINED, Params.new_params("other", description))
      end
      attributes_html += (((((Attributes.i18n_attributes("characters-under-limit", UNDEFINED, p.get("charactersUnderLimitText")) + Attributes.i18n_attributes("characters-at-limit", p.get("charactersAtLimitText"), UNDEFINED)) + Attributes.i18n_attributes("characters-over-limit", UNDEFINED, p.get("charactersOverLimitText"))) + Attributes.i18n_attributes("words-under-limit", UNDEFINED, p.get("wordsUnderLimitText"))) + Attributes.i18n_attributes("words-at-limit", p.get("wordsAtLimitText"), UNDEFINED)) + Attributes.i18n_attributes("words-over-limit", UNDEFINED, p.get("wordsOverLimitText")))
      attributes_html += appended_attributes(Nunjucks.get(form_group, "attributes"))
      label = p.get("label")
      return Nunjucks.trim(render_textarea(Params.new_params("id", id_, "name", p.get("name"), "describedBy", (Nunjucks.str_value(id_) + "-info"), "rows", p.get("rows"), "spellcheck", p.get("spellcheck"), "value", p.get("value"), "formGroup", Params.new_params("classes", ("govuk-character-count" + Nunjucks.concat_if(" ", Nunjucks.get(form_group, "classes"))), "attributes", attributes_html, "beforeInput", Nunjucks.get(form_group, "beforeInput"), "afterInput", Params.new_params("html", Safe.new(count_message_html))), "classes", ("govuk-js-character-count" + Nunjucks.concat_if(" ", p.get("classes"))), "label", Params.new_params("html", Nunjucks.get(label, "html"), "text", Nunjucks.get(label, "text"), "classes", Nunjucks.get(label, "classes"), "isPageHeading", Nunjucks.get(label, "isPageHeading"), "attributes", Nunjucks.get(label, "attributes"), "for", id_), "hint", p.get("hint"), "errorMessage", p.get("errorMessage"), "attributes", p.get("attributes"))))
    end
    
    def appended_attributes(attributes)
      if !(attributes.is_a?(Params))
        return ""
      end
      parts = []
      attributes.each do |name|
        (parts << ((((" " + Nunjucks.escape(name)) + "=\"") + Nunjucks.escape(Nunjucks.str_value(attributes.get(name)))) + "\""))
      end
      return parts.join("")
    end
    
    def render_password_input(p)
      id_ = component_id(p)
      form_group = p.get("formGroup")
      attributes_html = (((((((" data-module=\"govuk-password-input\"" + Attributes.i18n_attributes("show-password", p.get("showPasswordText"), UNDEFINED)) + Attributes.i18n_attributes("hide-password", p.get("hidePasswordText"), UNDEFINED)) + Attributes.i18n_attributes("show-password-aria-label", p.get("showPasswordAriaLabelText"), UNDEFINED)) + Attributes.i18n_attributes("hide-password-aria-label", p.get("hidePasswordAriaLabelText"), UNDEFINED)) + Attributes.i18n_attributes("password-shown-announcement", p.get("passwordShownAnnouncementText"), UNDEFINED)) + Attributes.i18n_attributes("password-hidden-announcement", p.get("passwordHiddenAnnouncementText"), UNDEFINED)) + appended_attributes(Nunjucks.get(form_group, "attributes")))
      button = p.get("button")
      button_html = (Nunjucks.trim(ComponentsButton.render_button(Params.new_params("type", "button", "classes", ("govuk-button--secondary govuk-password-input__toggle govuk-js-password-input-toggle" + Nunjucks.concat_if(" ", Nunjucks.get(button, "classes"))), "text", Nunjucks.default(p.get("showPasswordText"), "Show"), "attributes", Params.new_params("aria-controls", id_, "aria-label", Nunjucks.default(p.get("showPasswordAriaLabelText"), "Show password"), "hidden", Params.new_params("value", true, "optional", true))))) + "\n")
      after = Nunjucks.get(form_group, "afterInput")
      if Nunjucks.truthy?(after)
        html = Nunjucks.get(after, "html")
        if Nunjucks.truthy?(html)
          button_html += (Nunjucks.trim(Nunjucks.str_value(html)) + "\n")
        else
          button_html += (Nunjucks.out(Nunjucks.get(after, "text")) + "\n")
        end
      end
      return Nunjucks.trim(render_input(Params.new_params("formGroup", Params.new_params("classes", ("govuk-password-input" + Nunjucks.concat_if(" ", Nunjucks.get(form_group, "classes"))), "attributes", attributes_html, "beforeInput", Nunjucks.get(form_group, "beforeInput"), "afterInput", Params.new_params("html", Safe.new(button_html))), "inputWrapper", Params.new_params("classes", "govuk-password-input__wrapper"), "label", p.get("label"), "hint", p.get("hint"), "classes", ("govuk-password-input__input govuk-js-password-input-input" + Nunjucks.concat_if(" ", p.get("classes"))), "errorMessage", p.get("errorMessage"), "id", id_, "name", p.get("name"), "type", "password", "spellcheck", false, "autocapitalize", "none", "autocomplete", Nunjucks.default_truthy(p.get("autocomplete"), "current-password"), "value", p.get("value"), "disabled", p.get("disabled"), "describedBy", p.get("describedBy"), "attributes", p.get("attributes"))))
    end
    
    def render_checkboxes(p)
      id_prefix = p.get("idPrefix")
      if !(Nunjucks.truthy?(id_prefix))
        id_prefix = p.get("name")
      end
      fieldset = p.get("fieldset")
      described_by = ""
      supplied = p.get("describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      supplied = Nunjucks.get(fieldset, "describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      has_fieldset = Nunjucks.truthy?(fieldset)
      inner = []
      hint, described_by = hint_block(p, Nunjucks.str_value(id_prefix), described_by, 2)
      (inner << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(id_prefix), described_by, 2)
      (inner << error_message)
      form_group = p.get("formGroup")
      (inner << (((("  <div class=\"govuk-checkboxes" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + " data-module=\"govuk-checkboxes\">\n"))
      before = Nunjucks.get(form_group, "beforeInputs")
      if Nunjucks.truthy?(before)
        (inner << (("    " + slot_content(before, 4, false)) + "\n"))
      end
      Nunjucks.items(p.get("items")).each_with_index do |item, index|
        if !(Nunjucks.truthy?(item))
          next
        end
        (inner << _checkbox_item(p, item, (index + 1), Nunjucks.str_value(id_prefix), described_by, has_fieldset))
      end
      after = Nunjucks.get(form_group, "afterInputs")
      if Nunjucks.truthy?(after)
        (inner << (("    " + slot_content(after, 4, false)) + "\n"))
      end
      (inner << "  </div>\n")
      return fieldset_wrapper(p, inner.join(""), described_by, UNDEFINED, false)
    end
    
    def fieldset_wrapper(p, inner, described_by, role, indent_fieldset)
      fieldset = p.get("fieldset")
      body = Nunjucks.trim(inner)
      if Nunjucks.truthy?(fieldset)
        html = ComponentsText.render_fieldset(Params.new_params("describedBy", described_by, "classes", Nunjucks.get(fieldset, "classes"), "role", role, "attributes", Nunjucks.get(fieldset, "attributes"), "legend", Nunjucks.get(fieldset, "legend"), "html", Safe.new(body)))
        body = Nunjucks.trim(html)
        if indent_fieldset
          body = Nunjucks.indent(body, 2, false)
        end
      end
      return (((form_group_open(p) + "  ") + body) + "\n</div>")
    end
    
    def _checkbox_item(p, item, index, id_prefix, described_by, has_fieldset)
      item_id = id_prefix
      if (index > 1)
        item_id += ("-" + index.to_s)
      end
      supplied = Nunjucks.get(item, "id")
      if Nunjucks.truthy?(supplied)
        item_id = Nunjucks.str_value(supplied)
      end
      item_name = p.get("name")
      supplied = Nunjucks.get(item, "name")
      if Nunjucks.truthy?(supplied)
        item_name = supplied
      end
      conditional_id = ("conditional-" + item_id)
      divider = Nunjucks.get(item, "divider")
      if Nunjucks.truthy?(divider)
        return (("    <div class=\"govuk-checkboxes__divider\">" + Nunjucks.out(divider)) + "</div>\n")
      end
      checked = Nunjucks.truthy?(Nunjucks.get(item, "checked"))
      if (!(checked) && Nunjucks.truthy?(p.get("values")))
        checked = (Nunjucks.contains?(Nunjucks.get(item, "value"), p.get("values")) && !(Nunjucks.loose_eq(Nunjucks.get(item, "checked"), false)))
      end
      hint = Nunjucks.get(item, "hint")
      has_hint = (Nunjucks.truthy?(Nunjucks.get(hint, "text")) || Nunjucks.truthy?(Nunjucks.get(hint, "html")))
      item_hint_id = ""
      if has_hint
        item_hint_id = (item_id + "-item-hint")
      end
      item_described_by = ""
      if !(has_fieldset)
        item_described_by = described_by
      end
      item_described_by = Nunjucks.trim(((item_described_by + " ") + item_hint_id))
      conditional = Nunjucks.get(item, "conditional")
      label = Nunjucks.get(item, "label")
      parts = []
      (parts << "    <div class=\"govuk-checkboxes__item\">\n")
      (parts << ((((((((((((("      <input class=\"govuk-checkboxes__input\" id=\"" + Nunjucks.escape(item_id)) + "\" name=\"") + Nunjucks.out(item_name)) + "\" type=\"checkbox\" value=\"") + Nunjucks.out(Nunjucks.get(item, "value"))) + "\"") + Attributes.flag_if(" checked", checked)) + Attributes.flag_if(" disabled", Nunjucks.get(item, "disabled"))) + Attributes.attribute_if("data-aria-controls", _if_truthy(Nunjucks.get(conditional, "html"), conditional_id))) + Attributes.attribute_if("data-behaviour", Nunjucks.get(item, "behaviour"))) + Attributes.attribute_if("aria-describedby", item_described_by)) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">\n"))
      (parts << (("      " + Nunjucks.indent(Nunjucks.trim(ComponentsText.render_label(Params.new_params("html", Nunjucks.get(item, "html"), "text", Nunjucks.get(item, "text"), "classes", ("govuk-checkboxes__label" + Nunjucks.concat_if(" ", Nunjucks.get(label, "classes"))), "attributes", Nunjucks.get(label, "attributes"), "for", item_id))), 6, false)) + "\n"))
      if has_hint
        (parts << (("      " + Nunjucks.indent(Nunjucks.trim(ComponentsText.render_hint(Params.new_params("id", item_hint_id, "classes", ("govuk-checkboxes__hint" + Nunjucks.concat_if(" ", Nunjucks.get(hint, "classes"))), "attributes", Nunjucks.get(hint, "attributes"), "html", Nunjucks.get(hint, "html"), "text", Nunjucks.get(hint, "text")))), 6, false)) + "\n"))
      end
      (parts << "    </div>\n")
      html = Nunjucks.get(conditional, "html")
      if Nunjucks.truthy?(html)
        (parts << (((((("    <div class=\"govuk-checkboxes__conditional" + Attributes.flag_if(" govuk-checkboxes__conditional--hidden", !(checked))) + "\" id=\"") + Nunjucks.escape(conditional_id)) + "\">\n      ") + Nunjucks.trim(Nunjucks.str_value(html))) + "\n    </div>\n"))
      end
      return parts.join("")
    end
    
    def _if_truthy(condition, value)
      if Nunjucks.truthy?(condition)
        return value
      end
      return UNDEFINED
    end
    
    def render_radios(p)
      id_prefix = p.get("idPrefix")
      if !(Nunjucks.truthy?(id_prefix))
        id_prefix = p.get("name")
      end
      fieldset = p.get("fieldset")
      described_by = ""
      supplied = Nunjucks.get(fieldset, "describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      inner = []
      hint, described_by = hint_block(p, Nunjucks.str_value(id_prefix), described_by, 2)
      (inner << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(id_prefix), described_by, 2)
      (inner << error_message)
      form_group = p.get("formGroup")
      (inner << (((("  <div class=\"govuk-radios" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + " data-module=\"govuk-radios\">\n"))
      before = Nunjucks.get(form_group, "beforeInputs")
      if Nunjucks.truthy?(before)
        (inner << (("    " + slot_content(before, 4, false)) + "\n"))
      end
      Nunjucks.items(p.get("items")).each_with_index do |item, index|
        if !(Nunjucks.truthy?(item))
          next
        end
        (inner << _radio_item(p, item, (index + 1), Nunjucks.str_value(id_prefix)))
      end
      after = Nunjucks.get(form_group, "afterInputs")
      if Nunjucks.truthy?(after)
        (inner << (("    " + slot_content(after, 4, false)) + "\n"))
      end
      (inner << "  </div>\n")
      return fieldset_wrapper(p, inner.join(""), described_by, UNDEFINED, false)
    end
    
    def _radio_item(p, item, index, id_prefix)
      item_id = id_prefix
      if (index > 1)
        item_id += ("-" + index.to_s)
      end
      supplied = Nunjucks.get(item, "id")
      if Nunjucks.truthy?(supplied)
        item_id = Nunjucks.str_value(supplied)
      end
      conditional_id = ("conditional-" + item_id)
      divider = Nunjucks.get(item, "divider")
      if Nunjucks.truthy?(divider)
        return (("    <div class=\"govuk-radios__divider\">" + Nunjucks.out(divider)) + "</div>\n")
      end
      checked = Nunjucks.truthy?(Nunjucks.get(item, "checked"))
      if (!(checked) && Nunjucks.truthy?(p.get("value")))
        checked = (Nunjucks.loose_eq(Nunjucks.get(item, "value"), p.get("value")) && !(Nunjucks.loose_eq(Nunjucks.get(item, "checked"), false)))
      end
      hint = Nunjucks.get(item, "hint")
      has_hint = (Nunjucks.truthy?(Nunjucks.get(hint, "text")) || Nunjucks.truthy?(Nunjucks.get(hint, "html")))
      item_hint_id = (item_id + "-item-hint")
      conditional = Nunjucks.get(item, "conditional")
      label = Nunjucks.get(item, "label")
      parts = []
      (parts << "    <div class=\"govuk-radios__item\">\n")
      (parts << (((((((((((("      <input class=\"govuk-radios__input\" id=\"" + Nunjucks.escape(item_id)) + "\" name=\"") + Nunjucks.out(p.get("name"))) + "\" type=\"radio\" value=\"") + Nunjucks.out(Nunjucks.get(item, "value"))) + "\"") + Attributes.flag_if(" checked", checked)) + Attributes.flag_if(" disabled", Nunjucks.get(item, "disabled"))) + Attributes.attribute_if("data-aria-controls", _if_truthy(Nunjucks.get(conditional, "html"), conditional_id))) + Attributes.attribute_if("aria-describedby", _if_truthy(has_hint, item_hint_id))) + Attributes.attributes(Nunjucks.get(item, "attributes"))) + ">\n"))
      (parts << (("      " + Nunjucks.indent(Nunjucks.trim(ComponentsText.render_label(Params.new_params("html", Nunjucks.get(item, "html"), "text", Nunjucks.get(item, "text"), "classes", ("govuk-radios__label" + Nunjucks.concat_if(" ", Nunjucks.get(label, "classes"))), "attributes", Nunjucks.get(label, "attributes"), "for", item_id))), 6, false)) + "\n"))
      if has_hint
        (parts << (("      " + Nunjucks.indent(Nunjucks.trim(ComponentsText.render_hint(Params.new_params("id", item_hint_id, "classes", ("govuk-radios__hint" + Nunjucks.concat_if(" ", Nunjucks.get(hint, "classes"))), "attributes", Nunjucks.get(hint, "attributes"), "html", Nunjucks.get(hint, "html"), "text", Nunjucks.get(hint, "text")))), 6, false)) + "\n"))
      end
      (parts << "    </div>\n")
      html = Nunjucks.get(conditional, "html")
      if Nunjucks.truthy?(html)
        (parts << (((((("    <div class=\"govuk-radios__conditional" + Attributes.flag_if(" govuk-radios__conditional--hidden", !(checked))) + "\" id=\"") + Nunjucks.escape(conditional_id)) + "\">\n      ") + Nunjucks.trim(Nunjucks.str_value(html))) + "\n    </div>\n"))
      end
      return parts.join("")
    end
    
    def render_date_input(p)
      fieldset = p.get("fieldset")
      described_by = ""
      supplied = Nunjucks.get(fieldset, "describedBy")
      if Nunjucks.truthy?(supplied)
        described_by = Nunjucks.str_value(supplied)
      end
      values = p.get("values")
      day = Nunjucks.default(p.get("day"), Params.new_params("name", "day", "value", Nunjucks.get(values, "day"), "classes", "govuk-input--width-2"))
      month = Nunjucks.default(p.get("month"), Params.new_params("name", "month", "value", Nunjucks.get(values, "month"), "classes", "govuk-input--width-2"))
      year = Nunjucks.default(p.get("year"), Params.new_params("name", "year", "value", Nunjucks.get(values, "year"), "classes", "govuk-input--width-4"))
      date_items = Nunjucks.items(p.get("items"))
      if (date_items.length == 0)
        date_items = [day, month, year]
      end
      any_item_has_error = false
      date_items.each do |item|
        if _date_item_has_error(item)
          any_item_has_error = true
        end
      end
      inner = []
      hint, described_by = hint_block(p, Nunjucks.str_value(p.get("id")), described_by, 2)
      (inner << hint)
      error_message, described_by = error_block(p, Nunjucks.str_value(p.get("id")), described_by, 2)
      (inner << error_message)
      form_group = p.get("formGroup")
      (inner << ((((("  <div class=\"govuk-date-input" + Attributes.classes_if(p.get("classes"))) + "\"") + Attributes.attributes(p.get("attributes"))) + Attributes.attribute_if("id", p.get("id"))) + ">\n"))
      before = Nunjucks.get(form_group, "beforeInputs")
      if Nunjucks.truthy?(before)
        (inner << (("    " + slot_content(before, 4, false)) + "\n"))
      end
      date_items.each do |item|
        if !(Nunjucks.truthy?(item))
          next
        end
        (inner << (Nunjucks.indent(Nunjucks.trim(_date_input_item(p, item, any_item_has_error, day, month, year)), 4, true) + "\n"))
      end
      after = Nunjucks.get(form_group, "afterInputs")
      if Nunjucks.truthy?(after)
        (inner << (("    " + slot_content(after, 4, false)) + "\n"))
      end
      (inner << "  </div>\n")
      return fieldset_wrapper(p, inner.join(""), described_by, "group", true)
    end
    
    def _date_item_has_error(item)
      if Nunjucks.truthy?(Nunjucks.get(item, "error"))
        return true
      end
      classes = Nunjucks.get(item, "classes")
      return (Nunjucks.truthy?(classes) && Nunjucks.contains?("govuk-input--error", classes))
    end
    
    def _date_input_item(p, item, any_item_has_error, day, month, year)
      item_name = Nunjucks.get(item, "name")
      item_value = Nunjucks.get(item, "value")
      item_width = "2"
      item_classes = ""
      item_has_error = _date_item_has_error(item)
      name = Nunjucks.get(item, "name")
      if (item.equal?(day) || (Nunjucks.truthy?(name) && Nunjucks.contains?(name, ["day", Nunjucks.get(day, "name")])))
        item_name = Nunjucks.default(name, "day")
        item_value = Nunjucks.default(item_value, Nunjucks.get(day, "value"))
      elsif (item.equal?(month) || (Nunjucks.truthy?(name) && Nunjucks.contains?(name, ["month", Nunjucks.get(month, "name")])))
        item_name = Nunjucks.default(name, "month")
        item_value = Nunjucks.default(item_value, Nunjucks.get(month, "value"))
      elsif (item.equal?(year) || (Nunjucks.truthy?(name) && Nunjucks.contains?(name, ["year", Nunjucks.get(year, "name")])))
        item_name = Nunjucks.default(name, "year")
        item_value = Nunjucks.default(item_value, Nunjucks.get(year, "value"))
        item_width = "4"
      end
      classes = Nunjucks.get(item, "classes")
      has_error_class = (Nunjucks.truthy?(classes) && Nunjucks.contains?("govuk-input--error", classes))
      if (!(has_error_class) && (item_has_error || (!(Nunjucks.loose_eq(Nunjucks.get(item, "error"), false)) && Nunjucks.truthy?(p.get("errorMessage")) && !(any_item_has_error))))
        item_classes = Nunjucks.trim((item_classes + " govuk-input--error"))
      end
      if (!(Nunjucks.truthy?(classes)) || !(Nunjucks.contains?("govuk-input--width-", classes)))
        item_classes = Nunjucks.trim(((item_classes + " govuk-input--width-") + item_width))
      end
      if Nunjucks.truthy?(classes)
        item_classes = Nunjucks.trim(((item_classes + " ") + Nunjucks.str_value(classes)))
      end
      name_prefix = ""
      prefix = p.get("namePrefix")
      if Nunjucks.truthy?(prefix)
        name_prefix = (Nunjucks.str_value(prefix) + "-")
      end
      label = Nunjucks.get(item, "label")
      if !(Nunjucks.truthy?(label))
        label = _capitalise(Nunjucks.str_value(item_name))
      end
      id_ = Nunjucks.get(item, "id")
      if !(Nunjucks.truthy?(id_))
        id_ = ((Nunjucks.str_value(p.get("id")) + "-") + Nunjucks.str_value(item_name))
      end
      value = item_value
      if Nunjucks.undefined?(value)
        value = Nunjucks.get(p.get("values"), (name_prefix + Nunjucks.str_value(item_name)))
      end
      input_html = render_input(Params.new_params("label", Params.new_params("text", label, "classes", "govuk-date-input__label"), "id", id_, "classes", ("govuk-date-input__input" + Nunjucks.concat_if(" ", item_classes)), "name", (name_prefix + Nunjucks.str_value(item_name)), "value", value, "type", "text", "inputmode", Nunjucks.default_truthy(Nunjucks.get(item, "inputmode"), "numeric"), "autocomplete", Nunjucks.get(item, "autocomplete"), "pattern", Nunjucks.get(item, "pattern"), "attributes", Nunjucks.get(item, "attributes")))
      return (("<div class=\"govuk-date-input__item\">\n  " + Nunjucks.indent(Nunjucks.trim(input_html), 2, false)) + "\n</div>")
    end
    
      def _capitalise(text)
        if (text == "")
          return ""
        end
        lowered = text.downcase
        return (lowered[0].upcase + lowered[1..])
      end
    
  end
end

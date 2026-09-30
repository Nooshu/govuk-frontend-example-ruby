# frozen_string_literal: true

require "cgi"

module Licence
  module GovukOptions
    module_function

    def error_summary(errors)
      return nil if errors.blank?

      {
        "titleText" => "There is a problem",
        "errorList" => errors.map { |err| { "text" => err.text, "href" => err.href } }
      }
    end

    def name_fields(application, errors)
      {
        firstName: text_input("first-name", "First name", application.first_name, errors,
                              { "autocomplete" => "given-name", "classes" => "govuk-input--width-20", "spellcheck" => false }),
        lastName: text_input("last-name", "Last name", application.last_name, errors,
                             { "autocomplete" => "family-name", "classes" => "govuk-input--width-20", "spellcheck" => false })
      }
    end

    def email_field(application, errors)
      {
        email: text_input(
          "email", "Email address", application.email, errors,
          {
            "type" => "email", "autocomplete" => "email", "spellcheck" => false,
            "classes" => "govuk-input--width-20",
            "hint" => { "text" => "We will send the decision to this address" },
            "label" => { "text" => "What is your email address?", "isPageHeading" => true, "classes" => "govuk-label--l" }
          }
        )
      }
    end

    def date_field(application, errors)
      date = {
        "id" => "date-of-birth",
        "namePrefix" => "date-of-birth",
        "fieldset" => {
          "legend" => { "text" => "What is your date of birth?", "isPageHeading" => true, "classes" => "govuk-fieldset__legend--l" }
        },
        "hint" => { "text" => "For example, 31 3 1980" },
        "items" => [
          { "name" => "day", "autocomplete" => "bday-day", "value" => application.day },
          { "name" => "month", "autocomplete" => "bday-month", "value" => application.month },
          { "name" => "year", "autocomplete" => "bday-year", "value" => application.year }
        ]
      }
      add_error(date, errors, "date-of-birth")
      { dateOfBirth: date }
    end

    def contact_fields(application, errors)
      telephone = text_input(
        "telephone", "Telephone number", application.telephone, errors,
        { "type" => "tel", "autocomplete" => "tel", "classes" => "govuk-input--width-20" }
      )
      conditional = Govuk.must_render("input", Govuk::Params.params_from_mapping(telephone))
      items = Options::CONTACT_OPTIONS.map do |option|
        if option.value == CONTACT_BY_TELEPHONE
          {
            "value" => option.value,
            "text" => option.text,
            "checked" => application.contact_by == CONTACT_BY_TELEPHONE,
            "conditional" => { "html" => Govuk::Safe.new(conditional) }
          }
        else
          {
            "value" => option.value,
            "text" => option.text,
            "id" => "contact-by",
            "checked" => application.contact_by == option.value
          }
        end
      end
      radios = {
        "idPrefix" => "contact-by",
        "name" => "contact-by",
        "fieldset" => {
          "legend" => { "text" => "How should we contact you?", "isPageHeading" => true, "classes" => "govuk-fieldset__legend--l" }
        },
        "hint" => { "text" => "We will use this if we need to ask about your application" },
        "items" => items
      }
      add_error(radios, errors, "contact-by")
      { radios: radios }
    end

    def region_fields(application, errors)
      chosen = application.regions
      items = Options::REGIONS.each_with_index.map do |region, index|
        item = { "value" => region.value, "text" => region.text, "checked" => chosen.include?(region.value) }
        item["id"] = "regions" if index.zero?
        item
      end
      items << { "divider" => "or" }
      items << {
        "value" => NOT_SURE,
        "text" => "I have not decided yet",
        "behaviour" => "exclusive",
        "checked" => chosen.include?(NOT_SURE)
      }
      checkboxes = {
        "idPrefix" => "where",
        "name" => "regions",
        "fieldset" => {
          "legend" => { "text" => "Where will you fish?", "isPageHeading" => true, "classes" => "govuk-fieldset__legend--l" }
        },
        "hint" => { "text" => "Select all that apply" },
        "items" => items
      }
      add_error(checkboxes, errors, "regions")
      { checkboxes: checkboxes }
    end

    def licence_fields(application, errors)
      items = Options::LICENCE_LENGTHS.each_with_index.map do |option, index|
        item = {
          "value" => option.value,
          "text" => "#{option.text} (#{option.fee})",
          "checked" => application.licence_length == option.value
        }
        item["id"] = "licence-length" if index.zero?
        item
      end
      radios = {
        "idPrefix" => "licence-length",
        "name" => "licence-length",
        "fieldset" => {
          "legend" => {
            "text" => "How long do you need a licence for?",
            "isPageHeading" => true,
            "classes" => "govuk-fieldset__legend--l"
          }
        },
        "items" => items
      }
      add_error(radios, errors, "licence-length")
      { radios: radios }
    end

    def month_field(application, errors, now = nil)
      months = Options.start_months(now)
      items = [{ "value" => "", "text" => "Select a month", "selected" => application.start_month == "" }]
      months.each do |month|
        items << {
          "value" => month.value,
          "text" => month.text,
          "selected" => application.start_month == month.value
        }
      end
      field = {
        "id" => "start-month",
        "name" => "start-month",
        "label" => {
          "text" => "When should the licence start?",
          "isPageHeading" => true,
          "classes" => "govuk-label--l"
        },
        "items" => items
      }
      add_error(field, errors, "start-month")
      { select: field }
    end

    def address_fields(application, errors)
      line1 = text_input("address-line-1", "Address line 1", application.address_line_1, errors, { "autocomplete" => "address-line1" })
      line2 = text_input("address-line-2", "Address line 2 (optional)", application.address_line_2, errors, { "autocomplete" => "address-line2" })
      town = text_input("town", "Town or city", application.town, errors, { "autocomplete" => "address-level2", "classes" => "govuk-input--width-20" })
      postcode = text_input(
        "postcode", "Postcode", application.postcode, errors,
        { "autocomplete" => "postal-code", "classes" => "govuk-input--width-10", "spellcheck" => false }
      )
      lines =
        Govuk.must_render("input", Govuk::Params.params_from_mapping(line1)) +
        Govuk.must_render("input", Govuk::Params.params_from_mapping(line2)) +
        Govuk.must_render("input", Govuk::Params.params_from_mapping(town)) +
        Govuk.must_render("input", Govuk::Params.params_from_mapping(postcode))
      {
        fieldset: {
          "legend" => { "text" => "What is your address?", "isPageHeading" => true, "classes" => "govuk-fieldset__legend--l" },
          "html" => Govuk::Safe.new(lines)
        },
        inset: {
          "text" => "This example asks you to type your address. It does not look up addresses from a postcode."
        }
      }
    end

    def evidence_field(application, errors)
      upload = {
        "id" => "evidence",
        "name" => "evidence",
        "label" => { "text" => "Upload evidence of a concession", "isPageHeading" => true, "classes" => "govuk-label--l" },
        "hint" => { "text" => "PDF, PNG, or JPG. You can skip this question if you do not have a concession." }
      }
      add_error(upload, errors, "evidence")
      { currentFile: application.evidence_filename, upload: upload }
    end

    def details_field(application, errors)
      details = {
        "name" => "additional-details",
        "id" => "additional-details",
        "maxlength" => 200,
        "threshold" => 75,
        "value" => application.additional_details,
        "label" => { "text" => "Is there anything else we should know?", "isPageHeading" => true, "classes" => "govuk-label--l" },
        "hint" => { "text" => "You can skip this question. Do not include payment card numbers or passwords." }
      }
      add_error(details, errors, "additional-details")
      { details: details }
    end

    def password_fields(errors)
      password = {
        "id" => "password",
        "name" => "password",
        "autocomplete" => "new-password",
        "label" => { "text" => "Create a password", "isPageHeading" => true, "classes" => "govuk-label--l" },
        "hint" => { "text" => "Must be at least 8 characters. This example does not store your password." }
      }
      add_error(password, errors, "password")
      confirm = {
        "id" => "password-confirm",
        "name" => "password-confirm",
        "autocomplete" => "new-password",
        "label" => { "text" => "Confirm password" }
      }
      add_error(confirm, errors, "password-confirm")
      { password: password, confirm: confirm }
    end

    def cookie_fields(choice, errors)
      selected = case choice
                 when "accept" then "yes"
                 when "reject" then "no"
                 else ""
                 end
      radios = {
        "idPrefix" => "analytics",
        "name" => "analytics",
        "fieldset" => {
          "legend" => {
            "text" => "Do you want to accept analytics cookies?",
            "isPageHeading" => true,
            "classes" => "govuk-fieldset__legend--l"
          }
        },
        "hint" => { "text" => "This example stores your choice. It does not set analytics cookies." },
        "items" => [
          { "value" => "yes", "text" => "Yes", "id" => "analytics", "checked" => selected == "yes" },
          { "value" => "no", "text" => "No", "checked" => selected == "no" }
        ]
      }
      add_error(radios, errors, "analytics")
      { radios: radios }
    end

    def fees_table
      {
        "caption" => "Rod licence fees",
        "captionClasses" => "govuk-table__caption--m",
        "firstCellIsHeader" => true,
        "head" => [{ "text" => "Licence" }, { "text" => "Fee", "format" => "numeric" }],
        "rows" => Options::LICENCE_LENGTHS.map { |option| [{ "text" => option.text }, { "text" => option.fee, "format" => "numeric" }] }
      }
    end

    def help_accordion
      {
        "id" => "help",
        "items" => [
          {
            "heading" => { "text" => "Who can apply" },
            "content" => { "text" => "You can apply if you are 13 or over and you will fish with a rod in England or Wales." }
          },
          {
            "heading" => { "text" => "What a licence covers" },
            "content" => {
              "html" => Govuk::Safe.new(
                '<ul class="govuk-list govuk-list--bullet">' \
                "<li>Rod and line fishing</li>" \
                "<li>Up to 2 rods where the licence allows it</li>" \
                "<li>The dates printed on your licence</li></ul>"
              )
            }
          },
          {
            "heading" => { "text" => "If you need help to apply" },
            "content" => {
              "text" => "You can ask someone to apply for you. This example service does not offer a phone application line."
            }
          }
        ]
      }
    end

    def guidance_tabs
      {
        "id" => "guidance",
        "items" => [
          {
            "label" => "Before you apply",
            "id" => "before-you-apply",
            "panel" => {
              "html" => Govuk::Safe.new(
                '<h2 class="govuk-heading-l">Before you apply</h2>' \
                '<p class="govuk-body">You need your name, date of birth, email address, and home address.</p>'
              )
            }
          },
          {
            "label" => "Fees",
            "id" => "fees",
            "panel" => {
              "html" => Govuk::Safe.new(
                '<h2 class="govuk-heading-l">Fees</h2>' \
                '<p class="govuk-body">Fees depend on the length of the licence. ' \
                '<a class="govuk-link" href="/fees">See licence fees</a>.</p>'
              )
            }
          },
          {
            "label" => "After you apply",
            "id" => "after-you-apply",
            "panel" => {
              "html" => Govuk::Safe.new(
                '<h2 class="govuk-heading-l">After you apply</h2>' \
                '<p class="govuk-body">This example shows a confirmation page with a ' \
                "reference number. It does not send email and it does not take payment.</p>"
              )
            }
          }
        ]
      }
    end

    def confirmation_panel(reference)
      {
        "titleText" => "Application complete",
        "html" => Govuk::Safe.new("Your reference number<br><strong>#{CGI.escapeHTML(reference)}</strong>")
      }
    end

    def text_input(field_id, label, value, errors, extra)
      field = { "id" => field_id, "name" => field_id, "label" => { "text" => label }, "value" => value }
      field.merge!(extra)
      add_error(field, errors, field_id)
      field
    end
    private_class_method :text_input

    def add_error(params, errors, field)
      err = Array(errors).find { |item| item.field == field }
      params["errorMessage"] = { "text" => err.text } if err
    end
    private_class_method :add_error
  end
end

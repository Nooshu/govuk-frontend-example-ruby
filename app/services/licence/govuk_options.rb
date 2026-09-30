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

    def name_field(application, errors)
      {
        fullName: text_input(
          "full-name", "What is your full name?", application.full_name, errors,
          {
            "autocomplete" => "name",
            "label" => {
              "text" => "What is your full name?",
              "isPageHeading" => true,
              "classes" => "govuk-label--l"
            }
          }
        )
      }
    end

    def email_field(application, errors)
      {
        email: text_input(
          "email", "What is your email address?", application.email, errors,
          {
            "type" => "email", "autocomplete" => "email", "spellcheck" => false,
            "hint" => { "text" => "This example stores the address in your browser session only." },
            "label" => {
              "text" => "What is your email address?",
              "isPageHeading" => true,
              "classes" => "govuk-label--l"
            }
          }
        )
      }
    end

    def date_field(application, errors)
      date = {
        "id" => "date-of-birth",
        "namePrefix" => "date-of-birth",
        "fieldset" => {
          "legend" => {
            "text" => "What is your date of birth?",
            "isPageHeading" => true,
            "classes" => "govuk-fieldset__legend--l"
          }
        },
        "hint" => { "text" => "For example, 31 3 1980" },
        "items" => [
          { "name" => "day", "value" => application.day },
          { "name" => "month", "value" => application.month },
          { "name" => "year", "value" => application.year }
        ]
      }
      add_error(date, errors, "date-of-birth")
      { dateOfBirth: date }
    end

    def country_fields(application, errors)
      items = Options::COUNTRIES.each_with_index.map do |option, index|
        item = {
          "value" => option.value,
          "text" => option.text,
          "checked" => application.country == option.value
        }
        item["id"] = "country" if index.zero?
        item
      end
      radios = {
        "idPrefix" => "country",
        "name" => "country",
        "fieldset" => {
          "legend" => {
            "text" => "Where will you fish?",
            "isPageHeading" => true,
            "classes" => "govuk-fieldset__legend--l"
          }
        },
        "hint" => { "text" => "This example is fictional. It does not check a real fishing area." },
        "items" => items
      }
      add_error(radios, errors, "country")
      { radios: radios }
    end

    def licence_fields(application, errors)
      items = Options::LICENCE_LENGTHS.each_with_index.map do |option, index|
        item = {
          "value" => option.value,
          "text" => option.text,
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
            "text" => "How long do you need the licence for?",
            "isPageHeading" => true,
            "classes" => "govuk-fieldset__legend--l"
          }
        },
        "items" => items
      }
      add_error(radios, errors, "licence-length")
      { radios: radios }
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
        "rows" => Options::LICENCE_FEES.map { |option| [{ "text" => option.text }, { "text" => option.fee, "format" => "numeric" }] }
      }
    end

    def help_accordion
      {
        "id" => "help",
        "items" => [
          {
            "heading" => { "text" => "Who can apply" },
            "content" => {
              "text" => "You can apply if you are 13 or over and you will fish with a rod in England, Wales or Scotland."
            }
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
                '<p class="govuk-body">You need how long you need the licence, your name, date of birth, ' \
                "the country where you will fish, and your email address.</p>"
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
        "html" => Govuk::Safe.new("Your example reference number<br><strong>#{CGI.escapeHTML(reference)}</strong>")
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

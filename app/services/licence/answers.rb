# frozen_string_literal: true

require "date"

module Licence
  module Answers
    module_function

    def summary_rows(application, now = nil)
      clock = now || Time.now.utc
      [
        row("Name", join_name(application), "/name", "name"),
        row("Date of birth", format_date_of_birth(application), "/date-of-birth", "date of birth"),
        row("Email address", application.email, "/email", "email address"),
        row("Contact preference", Options.label_for(Options::CONTACT_OPTIONS, application.contact_by), "/contact-preference", "contact preference"),
        row("Telephone number", application.telephone, "/contact-preference", "telephone number"),
        row("Where you will fish", format_regions(application.regions), "/where-you-will-fish", "where you will fish"),
        row("Licence length", Options.label_for(Options.licence_length_options, application.licence_length), "/licence-length", "licence length"),
        row("Start month", Options.label_for(Options.start_months(clock), application.start_month), "/start-month", "start month"),
        row("Address", format_address(application), "/address", "address"),
        row("Evidence", application.evidence_filename, "/evidence", "evidence"),
        row("Additional details", application.additional_details, "/additional-details", "additional details"),
        row("Password", application.password_created ? "Set" : "", "/create-a-password", "password")
      ]
    end

    def task_sections(application)
      ready = Steps.required_complete?(application)
      [
        TaskSection.new(heading: "Personal details", id_prefix: "personal-details", items: [
                          task(application, STEP_NAME, "Your name"),
                          task(application, STEP_DATE_OF_BIRTH, "Date of birth"),
                          task(application, STEP_EMAIL, "Email address"),
                          task(application, STEP_CONTACT_PREFERENCE, "Contact preference")
                        ]),
        TaskSection.new(heading: "Your licence", id_prefix: "your-licence", items: [
                          task(application, STEP_WHERE_YOU_WILL_FISH, "Where you will fish"),
                          task(application, STEP_LICENCE_LENGTH, "Licence length"),
                          task(application, STEP_START_MONTH, "Start month")
                        ]),
        TaskSection.new(heading: "More about you", id_prefix: "more-about-you", items: [
                          task(application, STEP_ADDRESS, "Your address"),
                          task(application, STEP_EVIDENCE, "Concession evidence"),
                          task(application, STEP_ADDITIONAL_DETAILS, "Additional details"),
                          task(application, STEP_CREATE_A_PASSWORD, "Password")
                        ]),
        TaskSection.new(heading: "Apply", id_prefix: "apply", items: [submit_task(application, ready)])
      ]
    end

    def submit_task(application, ready)
      item = { "title" => { "text" => "Check your answers and submit" } }
      if !ready
        item["status"] = not_started_tag("Cannot start yet")
      elsif application.submitted
        item["href"] = "/check-answers"
        item["status"] = { "text" => "Completed" }
      else
        item["href"] = "/check-answers"
        item["status"] = not_started_tag("Not started")
      end
      item
    end
    private_class_method :submit_task

    def task(application, step_id, text)
      status = application.completed?(step_id) ? { "text" => "Completed" } : not_started_tag("Not started")
      { "title" => { "text" => text }, "href" => "/#{step_id}", "status" => status }
    end
    private_class_method :task

    def not_started_tag(text)
      { "tag" => { "text" => text, "classes" => "govuk-tag--grey" } }
    end
    private_class_method :not_started_tag

    def row(key, value, href, hidden)
      shown = value.to_s.strip.empty? ? "Not provided" : value.to_s.strip
      {
        "key" => { "text" => key },
        "value" => { "text" => shown },
        "actions" => {
          "items" => [
            { "href" => "#{href}?return=check-answers", "text" => "Change", "visuallyHiddenText" => hidden }
          ]
        }
      }
    end
    private_class_method :row

    def join_name(application)
      "#{application.first_name} #{application.last_name}".strip
    end
    private_class_method :join_name

    def format_date_of_birth(application)
      day = Integer(application.day, exception: false)
      month = Integer(application.month, exception: false)
      year = Integer(application.year, exception: false)
      return "" if day.nil? || month.nil? || year.nil? || day.zero? || month.zero? || year.zero?

      begin
        dob = Date.new(year, month, day)
      rescue ArgumentError
        return ""
      end
      "#{dob.day} #{dob.strftime('%B %Y')}"
    end
    private_class_method :format_date_of_birth

    def format_regions(selected)
      return "Not decided yet" if selected.include?(NOT_SURE)

      selected.map { |region| Options.label_for(Options::REGIONS, region) }.join(", ")
    end
    private_class_method :format_regions

    def format_address(application)
      [application.address_line_1, application.address_line_2, application.town, application.postcode]
        .map(&:strip)
        .reject(&:empty?)
        .join(", ")
    end
    private_class_method :format_address
  end
end

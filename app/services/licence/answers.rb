# frozen_string_literal: true

module Licence
  module Answers
    module_function

    def summary_rows(application)
      [
        row(
          "Licence length",
          Options.label_for(Options::LICENCE_LENGTHS, application.licence_length),
          "/licence-length",
          "licence length"
        ),
        row("Name", application.full_name, "/name", "name"),
        row("Date of birth", format_date_of_birth(application), "/date-of-birth", "date of birth"),
        row("Where you will fish", application.country, "/where-you-will-fish", "where you will fish"),
        row("Email address", application.email, "/email", "email address")
      ]
    end

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

    def format_date_of_birth(application)
      day = application.day.to_s.strip
      month = application.month.to_s.strip
      year = application.year.to_s.strip
      return "" if day.empty? || month.empty? || year.empty?

      "#{day} #{month} #{year}"
    end
    private_class_method :format_date_of_birth
  end
end

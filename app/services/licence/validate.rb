# frozen_string_literal: true

require "date"

module Licence
  module Validate
    module_function

    EMAIL = /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/
    ONE_OR_TWO = /\A[0-9]{1,2}\z/
    FOUR = /\A[0-9]{4}\z/

    def clean(value)
      value.to_s.strip
    end

    def validate_name(full_name)
      name = clean(full_name)
      if name.length < 2
        return [FieldError.new(field: "full-name", href: "#full-name", text: "Enter your full name")]
      end
      if name.length > 100
        return [
          FieldError.new(
            field: "full-name",
            href: "#full-name",
            text: "Full name must be 100 characters or fewer"
          )
        ]
      end

      []
    end

    def validate_date_of_birth(day, month, year, now = nil)
      day_s = clean(day)
      month_s = clean(month)
      year_s = clean(year)
      fail = ->(text) { [FieldError.new(field: "date-of-birth", href: "#date-of-birth-day", text: text)] }

      return fail.call("Enter your date of birth") if day_s.empty? || month_s.empty? || year_s.empty?
      return fail.call("Enter a real date of birth") unless ONE_OR_TWO.match?(day_s) && ONE_OR_TWO.match?(month_s) && FOUR.match?(year_s)

      begin
        dob = Date.new(year_s.to_i, month_s.to_i, day_s.to_i)
      rescue ArgumentError
        return fail.call("Enter a real date of birth")
      end

      today = (now || Time.now.utc).to_date
      return fail.call("Date of birth must be in the past") if dob > today
      return fail.call("You must be at least 13 to use this example") if age_on(dob, today) < 13

      []
    end

    def validate_email(email)
      return [] if EMAIL.match?(clean(email))

      [FieldError.new(field: "email", href: "#email", text: "Enter an email address in the correct format, like name@example.com")]
    end

    def validate_country(value)
      return [] if Options::COUNTRIES.any? { |option| option.value == value }

      [FieldError.new(field: "country", href: "#country", text: "Select where you will fish")]
    end

    def validate_licence_length(value)
      return [] if Options::LICENCE_LENGTHS.any? { |option| option.value == value }

      [FieldError.new(field: "licence-length", href: "#licence-length", text: "Select how long you need the licence for")]
    end

    def validate_cookie_choice(value)
      return [] if %w[yes no].include?(value)

      [FieldError.new(field: "analytics", href: "#analytics", text: "Select yes if you want to accept analytics cookies")]
    end

    def as_licence_length(value)
      [LICENCE_ONE_DAY, LICENCE_EIGHT_DAYS, LICENCE_TWELVE_MONTHS].include?(value) ? value : ""
    end

    def age_on(dob, today)
      age = today.year - dob.year
      age -= 1 if today.month < dob.month || (today.month == dob.month && today.day < dob.day)
      age
    end
    private_class_method :age_on
  end
end

# frozen_string_literal: true

require "date"

module Licence
  module Validate
    module_function

    EMAIL = /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/
    PHONE = /\A[0-9+() -]{8,20}\z/
    POSTCODE = /\A[A-Z]{1,2}[0-9][A-Z0-9]? [0-9][A-Z]{2}\z/
    EVIDENCE = /\.(pdf|png|jpe?g)\z/i
    ONE_OR_TWO = /\A[0-9]{1,2}\z/
    FOUR = /\A[0-9]{4}\z/
    FILENAME = /\A[\w. -]+\z/

    def clean(value)
      value.to_s.strip
    end

    def validate_name(first_name, last_name)
      name_part("first-name", "First name", "Enter your first name", first_name) +
        name_part("last-name", "Last name", "Enter your last name", last_name)
    end

    def name_part(field, label, missing, value)
      trimmed = clean(value)
      return [FieldError.new(field: field, href: "##{field}", text: missing)] if trimmed.empty?
      return [FieldError.new(field: field, href: "##{field}", text: "#{label} must be 100 characters or fewer")] if trimmed.length > 100

      []
    end
    private_class_method :name_part

    def validate_date_of_birth(day, month, year, now = nil)
      day_s = clean(day)
      month_s = clean(month)
      year_s = clean(year)
      fail = ->(text) { [FieldError.new(field: "date-of-birth", href: "#date-of-birth-day", text: text)] }

      return fail.call("Date of birth must include a day, month and year") if day_s.empty? || month_s.empty? || year_s.empty?
      return fail.call("Date of birth must be a real date") unless ONE_OR_TWO.match?(day_s) && ONE_OR_TWO.match?(month_s) && FOUR.match?(year_s)

      begin
        dob = Date.new(year_s.to_i, month_s.to_i, day_s.to_i)
      rescue ArgumentError
        return fail.call("Date of birth must be a real date")
      end

      today = (now || Time.now.utc).to_date
      return fail.call("Date of birth must be in the past") if dob > today
      return fail.call("You must be 13 or over to apply for a rod licence") if age_on(dob, today) < 13

      []
    end

    def validate_email(email)
      return [] if EMAIL.match?(clean(email))

      [FieldError.new(field: "email", href: "#email", text: "Enter an email address in the correct format, like name@example.com")]
    end

    def validate_contact_preference(contact_by, telephone)
      errors = []
      unless [CONTACT_BY_EMAIL, CONTACT_BY_TELEPHONE].include?(contact_by)
        errors << FieldError.new(field: "contact-by", href: "#contact-by", text: "Select how we should contact you")
      end
      trimmed = clean(telephone)
      if contact_by == CONTACT_BY_TELEPHONE && trimmed.empty?
        errors << FieldError.new(field: "telephone", href: "#telephone", text: "Enter a telephone number")
      elsif !trimmed.empty? && !PHONE.match?(trimmed)
        errors << FieldError.new(field: "telephone", href: "#telephone", text: "Enter a telephone number, like 01632 960 001")
      end
      errors
    end

    def validate_regions(selected)
      problem = ->(text) { [FieldError.new(field: "regions", href: "#regions", text: text)] }
      return problem.call("Select where you will fish") if selected.blank?

      known = Options::REGIONS.map(&:value)
      chosen = []
      exclusive = false
      selected.each do |region|
        if region == NOT_SURE
          exclusive = true
        else
          chosen << region
        end
      end
      return problem.call("Select where you will fish, or select that you have not decided yet") if exclusive && chosen.any?
      return problem.call("Select where you will fish") if chosen.any? { |region| !known.include?(region) }

      []
    end

    def validate_licence_length(value)
      return [] if Options::LICENCE_LENGTHS.any? { |option| option.value == value }

      [FieldError.new(field: "licence-length", href: "#licence-length", text: "Select how long you need a licence for")]
    end

    def validate_start_month(value, now = nil)
      return [] if Options.start_months(now).any? { |month| month.value == value }

      [FieldError.new(field: "start-month", href: "#start-month", text: "Select when the licence should start")]
    end

    def validate_address(line1, town, postcode)
      errors = []
      trimmed_line1 = clean(line1)
      if trimmed_line1.empty?
        errors << FieldError.new(field: "address-line-1", href: "#address-line-1", text: "Enter address line 1")
      elsif trimmed_line1.length > 100
        errors << FieldError.new(field: "address-line-1", href: "#address-line-1", text: "Address line 1 must be 100 characters or fewer")
      end
      errors << FieldError.new(field: "town", href: "#town", text: "Enter a town or city") if clean(town).empty?
      normalised = normalise_postcode(postcode)
      errors << FieldError.new(field: "postcode", href: "#postcode", text: "Enter a full UK postcode") if normalised.empty? || !POSTCODE.match?(normalised)
      errors
    end

    def validate_evidence(filename)
      return [] if filename.to_s.empty?
      return [] if EVIDENCE.match?(filename)

      [FieldError.new(field: "evidence", href: "#evidence", text: "The selected file must be a PDF, PNG, or JPG")]
    end

    def validate_additional_details(value)
      return [] if value.to_s.length <= 200

      [FieldError.new(field: "additional-details", href: "#additional-details", text: "Additional details must be 200 characters or fewer")]
    end

    def validate_password(password, confirm)
      return [FieldError.new(field: "password", href: "#password", text: "Password must be at least 8 characters")] if password.to_s.length < 8
      return [FieldError.new(field: "password-confirm", href: "#password-confirm", text: "Enter the same password in both fields")] if password != confirm

      []
    end

    def validate_cookie_choice(value)
      return [] if %w[yes no].include?(value)

      [FieldError.new(field: "analytics", href: "#analytics", text: "Select yes if you want to accept analytics cookies")]
    end

    def normalise_postcode(value)
      compact = clean(value).upcase.delete(" ")
      return "" if compact.length < 5

      "#{compact[0...-3]} #{compact[-3..]}"
    end

    def as_contact_by(value)
      [CONTACT_BY_EMAIL, CONTACT_BY_TELEPHONE].include?(value) ? value : ""
    end

    def as_licence_length(value)
      [LICENCE_ONE_DAY, LICENCE_EIGHT_DAY, LICENCE_TWELVE_MTH].include?(value) ? value : ""
    end

    def safe_filename(filename)
      base = File.basename(filename.to_s.tr("\\", "/"))
      return nil if ["", ".", ".."].include?(base)
      return nil if base.length > 120 || !FILENAME.match?(base)

      base
    end

    def age_on(dob, today)
      age = today.year - dob.year
      age -= 1 if today.month < dob.month || (today.month == dob.month && today.day < dob.day)
      age
    end
    private_class_method :age_on
  end
end

# frozen_string_literal: true

module Licence
  module Save
    module_function

    def finish(completed, step_id, valid)
      valid ? Steps.mark_completed(completed, step_id) : Steps.unmark_completed(completed, step_id)
    end
    private_class_method :finish

    def name(application, first_name, last_name, valid:)
      application.first_name = Validate.clean(first_name)
      application.last_name = Validate.clean(last_name)
      application.completed = finish(application.completed, STEP_NAME, valid)
      application
    end

    def date(application, day, month, year, valid:)
      application.day = Validate.clean(day)
      application.month = Validate.clean(month)
      application.year = Validate.clean(year)
      application.completed = finish(application.completed, STEP_DATE_OF_BIRTH, valid)
      application
    end

    def email(application, email, valid:)
      application.email = Validate.clean(email)
      application.completed = finish(application.completed, STEP_EMAIL, valid)
      application
    end

    def contact(application, contact_by, telephone, valid:)
      application.contact_by = Validate.as_contact_by(contact_by)
      application.telephone = Validate.clean(telephone)
      application.completed = finish(application.completed, STEP_CONTACT_PREFERENCE, valid)
      application
    end

    def regions(application, selected, valid:)
      known = [NOT_SURE] + Options::REGIONS.map(&:value)
      application.regions = Array(selected).select { |region| known.include?(region) }
      application.completed = finish(application.completed, STEP_WHERE_YOU_WILL_FISH, valid)
      application
    end

    def licence(application, value, valid:)
      application.licence_length = Validate.as_licence_length(value)
      application.completed = finish(application.completed, STEP_LICENCE_LENGTH, valid)
      application
    end

    def month(application, value, valid:)
      application.start_month = value
      application.completed = finish(application.completed, STEP_START_MONTH, valid)
      application
    end

    def address(application, values, valid:)
      application.address_line_1 = Validate.clean(values.line1)
      application.address_line_2 = Validate.clean(values.line2)
      application.town = Validate.clean(values.town)
      application.postcode = valid ? Validate.normalise_postcode(values.postcode) : Validate.clean(values.postcode)
      application.completed = finish(application.completed, STEP_ADDRESS, valid)
      application
    end

    def evidence(application, filename, has_file:, valid:)
      application.evidence_filename = filename if has_file && valid
      application.completed = finish(application.completed, STEP_EVIDENCE, valid)
      application
    end

    def details(application, value, valid:)
      application.additional_details = value
      application.completed = finish(application.completed, STEP_ADDITIONAL_DETAILS, valid)
      application
    end

    def password(application, valid:)
      application.password_created = valid
      application.completed = finish(application.completed, STEP_CREATE_A_PASSWORD, valid)
      application
    end
  end
end

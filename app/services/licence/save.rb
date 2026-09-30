# frozen_string_literal: true

module Licence
  module Save
    module_function

    def finish(completed, step_id, valid)
      valid ? Steps.mark_completed(completed, step_id) : Steps.unmark_completed(completed, step_id)
    end
    private_class_method :finish

    def licence(application, value, valid:)
      application.licence_length = Validate.as_licence_length(value)
      application.completed = finish(application.completed, STEP_LICENCE_LENGTH, valid)
      application
    end

    def name(application, full_name, valid:)
      application.full_name = Validate.clean(full_name)
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

    def country(application, country, valid:)
      application.country = Validate.clean(country)
      application.completed = finish(application.completed, STEP_WHERE_YOU_WILL_FISH, valid)
      application
    end

    def email(application, email, valid:)
      application.email = Validate.clean(email)
      application.completed = finish(application.completed, STEP_EMAIL, valid)
      application
    end
  end
end

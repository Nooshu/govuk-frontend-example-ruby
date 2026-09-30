# frozen_string_literal: true

class JourneyController < ApplicationController
  STEPS = {
    "licence-length" => Licence::STEP_LICENCE_LENGTH,
    "name" => Licence::STEP_NAME,
    "date-of-birth" => Licence::STEP_DATE_OF_BIRTH,
    "where-you-will-fish" => Licence::STEP_WHERE_YOU_WILL_FISH,
    "email" => Licence::STEP_EMAIL
  }.freeze

  TEMPLATES = {
    Licence::STEP_LICENCE_LENGTH => "journey/licence_length",
    Licence::STEP_NAME => "journey/name",
    Licence::STEP_DATE_OF_BIRTH => "journey/date_of_birth",
    Licence::STEP_WHERE_YOU_WILL_FISH => "journey/where_you_will_fish",
    Licence::STEP_EMAIL => "journey/email"
  }.freeze

  def show
    @step = find_step!
    prepare_show
    render TEMPLATES[@step.id]
  end

  def update
    @step = find_step!
    data = bind_post
    errors = validate_data(data)
    application = apply_step(current_application, data, valid: errors.empty?)
    save_current_application(application)

    if errors.any?
      Licence::SessionState.set_errors(session, @step.path, errors.map(&:as_dict))
      target = @step.path
      target = "#{@step.path}?return=check-answers" if params[:returnTo] == "check-answers"
      redirect_to target
    else
      Licence::SessionState.clear_errors(session)
      if params[:returnTo] == "check-answers"
        redirect_to "/check-answers"
      else
        nxt = Licence::Steps.next_after(@step.id)
        redirect_to(nxt ? nxt.path : "/check-answers")
      end
    end
  end

  private

  def find_step!
    step_id = STEPS[params[:step]]
    raise ActionController::RoutingError, "Not Found" unless step_id

    Licence::Steps.by_id(step_id) || raise(ActionController::RoutingError, "Not Found")
  end

  def prepare_show
    application = current_application
    errors = errors_from_session(@step.path)
    return_to = params[:return] == "check-answers" ? "check-answers" : ""
    back = if return_to.present?
             "/check-answers"
           else
             previous = Licence::Steps.previous_before(@step.id)
             previous ? previous.path : "/"
           end

    layout_assign(
      heading: @step.heading,
      has_errors: errors.any?,
      back_link: { "text" => "Back", "href" => back },
      main_classes: "govuk-main-wrapper--l",
      personal: true
    )
    @return_to = return_to
    @continue_button = { "text" => "Continue" }
    @error_summary = Licence::GovukOptions.error_summary(errors)
    assign_fields(application, errors)
  end

  def assign_fields(application, errors)
    case @step.id
    when Licence::STEP_LICENCE_LENGTH
      @radios = Licence::GovukOptions.licence_fields(application, errors)[:radios]
    when Licence::STEP_NAME
      @full_name = Licence::GovukOptions.name_field(application, errors)[:fullName]
    when Licence::STEP_DATE_OF_BIRTH
      @date_of_birth = Licence::GovukOptions.date_field(application, errors)[:dateOfBirth]
    when Licence::STEP_WHERE_YOU_WILL_FISH
      @radios = Licence::GovukOptions.country_fields(application, errors)[:radios]
    when Licence::STEP_EMAIL
      @email = Licence::GovukOptions.email_field(application, errors)[:email]
    end
  end

  def bind_post
    case @step.id
    when Licence::STEP_LICENCE_LENGTH
      { "licence_length" => params["licence-length"].to_s }
    when Licence::STEP_NAME
      { "full_name" => params["full-name"].to_s }
    when Licence::STEP_DATE_OF_BIRTH
      {
        "day" => params["date-of-birth-day"].to_s,
        "month" => params["date-of-birth-month"].to_s,
        "year" => params["date-of-birth-year"].to_s
      }
    when Licence::STEP_WHERE_YOU_WILL_FISH
      { "country" => params["country"].to_s }
    else
      { "email" => params["email"].to_s }
    end
  end

  def validate_data(data)
    case @step.id
    when Licence::STEP_LICENCE_LENGTH
      Licence::Validate.validate_licence_length(data["licence_length"])
    when Licence::STEP_NAME
      Licence::Validate.validate_name(data["full_name"])
    when Licence::STEP_DATE_OF_BIRTH
      Licence::Validate.validate_date_of_birth(data["day"], data["month"], data["year"], Time.now.utc)
    when Licence::STEP_WHERE_YOU_WILL_FISH
      Licence::Validate.validate_country(data["country"])
    else
      Licence::Validate.validate_email(data["email"])
    end
  end

  def apply_step(application, data, valid:)
    case @step.id
    when Licence::STEP_LICENCE_LENGTH
      Licence::Save.licence(application, data["licence_length"], valid: valid)
    when Licence::STEP_NAME
      Licence::Save.name(application, data["full_name"], valid: valid)
    when Licence::STEP_DATE_OF_BIRTH
      Licence::Save.date(application, data["day"], data["month"], data["year"], valid: valid)
    when Licence::STEP_WHERE_YOU_WILL_FISH
      Licence::Save.country(application, data["country"], valid: valid)
    else
      Licence::Save.email(application, data["email"], valid: valid)
    end
  end
end

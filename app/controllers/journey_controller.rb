# frozen_string_literal: true

class JourneyController < ApplicationController
  STEPS = {
    "name" => Licence::STEP_NAME,
    "date-of-birth" => Licence::STEP_DATE_OF_BIRTH,
    "email" => Licence::STEP_EMAIL,
    "contact-preference" => Licence::STEP_CONTACT_PREFERENCE,
    "where-you-will-fish" => Licence::STEP_WHERE_YOU_WILL_FISH,
    "licence-length" => Licence::STEP_LICENCE_LENGTH,
    "start-month" => Licence::STEP_START_MONTH,
    "address" => Licence::STEP_ADDRESS,
    "evidence" => Licence::STEP_EVIDENCE,
    "additional-details" => Licence::STEP_ADDITIONAL_DETAILS,
    "create-a-password" => Licence::STEP_CREATE_A_PASSWORD
  }.freeze

  TEMPLATES = {
    Licence::STEP_NAME => "journey/name",
    Licence::STEP_DATE_OF_BIRTH => "journey/date_of_birth",
    Licence::STEP_EMAIL => "journey/email",
    Licence::STEP_CONTACT_PREFERENCE => "journey/contact_preference",
    Licence::STEP_WHERE_YOU_WILL_FISH => "journey/where_you_will_fish",
    Licence::STEP_LICENCE_LENGTH => "journey/licence_length",
    Licence::STEP_START_MONTH => "journey/start_month",
    Licence::STEP_ADDRESS => "journey/address",
    Licence::STEP_EVIDENCE => "journey/evidence",
    Licence::STEP_ADDITIONAL_DETAILS => "journey/additional_details",
    Licence::STEP_CREATE_A_PASSWORD => "journey/create_a_password"
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
             previous ? previous.path : "/task-list"
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
    @enctype = nil
    assign_fields(application, errors)
  end

  def assign_fields(application, errors)
    case @step.id
    when Licence::STEP_NAME
      fields = Licence::GovukOptions.name_fields(application, errors)
      @first_name = fields[:firstName]
      @last_name = fields[:lastName]
    when Licence::STEP_DATE_OF_BIRTH
      @date_of_birth = Licence::GovukOptions.date_field(application, errors)[:dateOfBirth]
    when Licence::STEP_EMAIL
      @email = Licence::GovukOptions.email_field(application, errors)[:email]
    when Licence::STEP_CONTACT_PREFERENCE
      @radios = Licence::GovukOptions.contact_fields(application, errors)[:radios]
    when Licence::STEP_WHERE_YOU_WILL_FISH
      @checkboxes = Licence::GovukOptions.region_fields(application, errors)[:checkboxes]
    when Licence::STEP_LICENCE_LENGTH
      @radios = Licence::GovukOptions.licence_fields(application, errors)[:radios]
    when Licence::STEP_START_MONTH
      @select = Licence::GovukOptions.month_field(application, errors, Time.now.utc)[:select]
    when Licence::STEP_ADDRESS
      fields = Licence::GovukOptions.address_fields(application, errors)
      @fieldset = fields[:fieldset]
      @inset = fields[:inset]
    when Licence::STEP_EVIDENCE
      fields = Licence::GovukOptions.evidence_field(application, errors)
      @upload = fields[:upload]
      @current_file = fields[:currentFile]
      @enctype = "multipart/form-data"
    when Licence::STEP_ADDITIONAL_DETAILS
      @details = Licence::GovukOptions.details_field(application, errors)[:details]
    when Licence::STEP_CREATE_A_PASSWORD
      fields = Licence::GovukOptions.password_fields(errors)
      @password = fields[:password]
      @confirm = fields[:confirm]
    end
  end

  def bind_post
    case @step.id
    when Licence::STEP_NAME
      { "first_name" => params["first-name"].to_s, "last_name" => params["last-name"].to_s }
    when Licence::STEP_DATE_OF_BIRTH
      {
        "day" => params["date-of-birth-day"].to_s,
        "month" => params["date-of-birth-month"].to_s,
        "year" => params["date-of-birth-year"].to_s
      }
    when Licence::STEP_EMAIL
      { "email" => params["email"].to_s }
    when Licence::STEP_CONTACT_PREFERENCE
      { "contact_by" => params["contact-by"].to_s, "telephone" => params["telephone"].to_s }
    when Licence::STEP_WHERE_YOU_WILL_FISH
      { "regions" => Array(params[:regions]).map(&:to_s) }
    when Licence::STEP_LICENCE_LENGTH
      { "licence_length" => params["licence-length"].to_s }
    when Licence::STEP_START_MONTH
      { "start_month" => params["start-month"].to_s }
    when Licence::STEP_ADDRESS
      {
        "address_line_1" => params["address-line-1"].to_s,
        "address_line_2" => params["address-line-2"].to_s,
        "town" => params["town"].to_s,
        "postcode" => params["postcode"].to_s
      }
    when Licence::STEP_EVIDENCE
      { "evidence" => evidence_filename }
    when Licence::STEP_ADDITIONAL_DETAILS
      { "additional_details" => params["additional-details"].to_s }
    else
      { "password" => params["password"].to_s, "password_confirm" => params["password-confirm"].to_s }
    end
  end

  def evidence_filename
    upload = params[:evidence]
    return "" unless upload.respond_to?(:original_filename)

    Licence::Validate.safe_filename(upload.original_filename).to_s
  end

  def validate_data(data)
    case @step.id
    when Licence::STEP_NAME
      Licence::Validate.validate_name(data["first_name"], data["last_name"])
    when Licence::STEP_DATE_OF_BIRTH
      Licence::Validate.validate_date_of_birth(data["day"], data["month"], data["year"], Time.now.utc)
    when Licence::STEP_EMAIL
      Licence::Validate.validate_email(data["email"])
    when Licence::STEP_CONTACT_PREFERENCE
      Licence::Validate.validate_contact_preference(data["contact_by"], data["telephone"])
    when Licence::STEP_WHERE_YOU_WILL_FISH
      Licence::Validate.validate_regions(data["regions"])
    when Licence::STEP_LICENCE_LENGTH
      Licence::Validate.validate_licence_length(data["licence_length"])
    when Licence::STEP_START_MONTH
      Licence::Validate.validate_start_month(data["start_month"], Time.now.utc)
    when Licence::STEP_ADDRESS
      Licence::Validate.validate_address(data["address_line_1"], data["town"], data["postcode"])
    when Licence::STEP_EVIDENCE
      Licence::Validate.validate_evidence(data["evidence"])
    when Licence::STEP_ADDITIONAL_DETAILS
      Licence::Validate.validate_additional_details(data["additional_details"])
    else
      Licence::Validate.validate_password(data["password"], data["password_confirm"])
    end
  end

  def apply_step(application, data, valid:)
    case @step.id
    when Licence::STEP_NAME
      Licence::Save.name(application, data["first_name"], data["last_name"], valid: valid)
    when Licence::STEP_DATE_OF_BIRTH
      Licence::Save.date(application, data["day"], data["month"], data["year"], valid: valid)
    when Licence::STEP_EMAIL
      Licence::Save.email(application, data["email"], valid: valid)
    when Licence::STEP_CONTACT_PREFERENCE
      Licence::Save.contact(application, data["contact_by"], data["telephone"], valid: valid)
    when Licence::STEP_WHERE_YOU_WILL_FISH
      Licence::Save.regions(application, data["regions"], valid: valid)
    when Licence::STEP_LICENCE_LENGTH
      Licence::Save.licence(application, data["licence_length"], valid: valid)
    when Licence::STEP_START_MONTH
      Licence::Save.month(application, data["start_month"], valid: valid)
    when Licence::STEP_ADDRESS
      Licence::Save.address(
        application,
        Licence::AddressValues.new(
          line1: data["address_line_1"],
          line2: data["address_line_2"],
          town: data["town"],
          postcode: data["postcode"]
        ),
        valid: valid
      )
    when Licence::STEP_EVIDENCE
      filename = data["evidence"]
      Licence::Save.evidence(application, filename, has_file: filename.present?, valid: valid)
    when Licence::STEP_ADDITIONAL_DETAILS
      Licence::Save.details(application, data["additional_details"], valid: valid)
    else
      Licence::Save.password(application, valid: valid)
    end
  end
end

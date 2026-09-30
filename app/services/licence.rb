# frozen_string_literal: true

module Licence
  CONTACT_BY_EMAIL = "email"
  CONTACT_BY_TELEPHONE = "telephone"
  LICENCE_ONE_DAY = "1-day"
  LICENCE_EIGHT_DAY = "8-day"
  LICENCE_TWELVE_MTH = "12-month"
  NOT_SURE = "not-sure"

  STEP_NAME = "name"
  STEP_DATE_OF_BIRTH = "date-of-birth"
  STEP_EMAIL = "email"
  STEP_CONTACT_PREFERENCE = "contact-preference"
  STEP_WHERE_YOU_WILL_FISH = "where-you-will-fish"
  STEP_LICENCE_LENGTH = "licence-length"
  STEP_START_MONTH = "start-month"
  STEP_ADDRESS = "address"
  STEP_EVIDENCE = "evidence"
  STEP_ADDITIONAL_DETAILS = "additional-details"
  STEP_CREATE_A_PASSWORD = "create-a-password"

  Step = Struct.new(:id, :path, :heading, keyword_init: true)

  STEPS = [
    Step.new(id: STEP_NAME, path: "/name", heading: "What is your name?"),
    Step.new(id: STEP_DATE_OF_BIRTH, path: "/date-of-birth", heading: "What is your date of birth?"),
    Step.new(id: STEP_EMAIL, path: "/email", heading: "What is your email address?"),
    Step.new(id: STEP_CONTACT_PREFERENCE, path: "/contact-preference", heading: "How should we contact you?"),
    Step.new(id: STEP_WHERE_YOU_WILL_FISH, path: "/where-you-will-fish", heading: "Where will you fish?"),
    Step.new(id: STEP_LICENCE_LENGTH, path: "/licence-length", heading: "How long do you need a licence for?"),
    Step.new(id: STEP_START_MONTH, path: "/start-month", heading: "When should the licence start?"),
    Step.new(id: STEP_ADDRESS, path: "/address", heading: "What is your address?"),
    Step.new(id: STEP_EVIDENCE, path: "/evidence", heading: "Upload evidence of a concession"),
    Step.new(id: STEP_ADDITIONAL_DETAILS, path: "/additional-details", heading: "Is there anything else we should know?"),
    Step.new(id: STEP_CREATE_A_PASSWORD, path: "/create-a-password", heading: "Create a password")
  ].freeze

  OPTIONAL_STEPS = [STEP_EVIDENCE, STEP_ADDITIONAL_DETAILS].freeze

  Option = Struct.new(:value, :text, keyword_init: true)
  LicenceOption = Struct.new(:value, :text, :fee, keyword_init: true)
  TaskSection = Struct.new(:heading, :id_prefix, :items, keyword_init: true)
  ResolvedAsset = Struct.new(:path, :body, :content_type, :kind, keyword_init: true)
  PageAssets = Struct.new(:stylesheet_href, :app_module_href, :script_href, :css_body, :script_body, :app_body, keyword_init: true)
end

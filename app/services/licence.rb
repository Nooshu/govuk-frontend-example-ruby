# frozen_string_literal: true

module Licence
  LICENCE_ONE_DAY = "1-day"
  LICENCE_EIGHT_DAYS = "8-days"
  LICENCE_TWELVE_MONTHS = "12-months"

  STEP_LICENCE_LENGTH = "licence-length"
  STEP_NAME = "name"
  STEP_DATE_OF_BIRTH = "date-of-birth"
  STEP_WHERE_YOU_WILL_FISH = "where-you-will-fish"
  STEP_EMAIL = "email"

  Step = Struct.new(:id, :path, :heading, keyword_init: true)

  STEPS = [
    Step.new(id: STEP_LICENCE_LENGTH, path: "/licence-length", heading: "How long do you need the licence for?"),
    Step.new(id: STEP_NAME, path: "/name", heading: "What is your full name?"),
    Step.new(id: STEP_DATE_OF_BIRTH, path: "/date-of-birth", heading: "What is your date of birth?"),
    Step.new(id: STEP_WHERE_YOU_WILL_FISH, path: "/where-you-will-fish", heading: "Where will you fish?"),
    Step.new(id: STEP_EMAIL, path: "/email", heading: "What is your email address?")
  ].freeze

  Option = Struct.new(:value, :text, keyword_init: true)
  FeeOption = Struct.new(:text, :fee, keyword_init: true)
  ResolvedAsset = Struct.new(:path, :body, :content_type, :kind, keyword_init: true)
  PageAssets = Struct.new(:stylesheet_href, :app_module_href, :script_href, :css_body, :script_body, :app_body, keyword_init: true)
end

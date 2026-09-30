# frozen_string_literal: true

require "govuk"
require "baseline/policy"

Rails.application.config.after_initialize do
  Baseline::Policy.load
end

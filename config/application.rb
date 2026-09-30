# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

require_relative "../app/middleware/baseline_headers"
require "rack/brotli"

module GovukFrontendExampleRuby
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.generators.system_tests = nil

    # Component catalogue and example pages (on in development/test; override with DEMOS_ENABLED).
    demos_env = ENV.fetch("DEMOS_ENABLED", nil)
    config.demos_enabled =
      if demos_env.nil?
        !Rails.env.production?
      else
        %w[1 true yes].include?(demos_env.downcase)
      end

    config.service_name = "Apply for a fishing rod licence"
    config.service_name_cy = "Gwneud cais am drwydded bysgota"
    config.govuk_frontend_version = "6.5.1"
    config.govuk_frontend_root = Rails.root.join("node_modules/govuk-frontend")
    config.govuk_components_dir = Rails.root.join("node_modules/govuk-frontend/dist/govuk/components")
    config.dist_dir = Rails.root.join("dist")
    config.baseline_policy_path = Rails.root.join("baseline/policy.json")

    config.middleware.use BaselineHeaders
    # Brotli when Accept-Encoding includes br; Gzip is Rack::Deflater fallback.
    config.middleware.use Rack::Brotli
    config.middleware.use Rack::Deflater
  end
end

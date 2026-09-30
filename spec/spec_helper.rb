# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  enable_coverage :branch
  skip "/spec/"
  skip "/config/"
  skip "/vendor/"
  cover "{app,lib}/**/*.rb"
  # Primary contract is 100% fixture HTML parity (fixture_parity_spec).
  # Application line coverage floor applies to the full suite (CI / `npm test`).
  minimum_coverage line: 95 unless ENV["COVERAGE_PARTIAL"]
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "tmp/rspec-examples.txt"
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end

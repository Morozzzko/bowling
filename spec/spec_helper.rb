# frozen_string_literal: true

require 'rack/test'
require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = 'doc'
  config.profile_examples = 10
  config.order = :random

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  Kernel.srand config.seed

  config.include Rack::Test::Methods, type: :http
end

require_relative '../boot'
require_relative 'support/factories'

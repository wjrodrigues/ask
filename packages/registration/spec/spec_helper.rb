# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.test')
ENV['RACK_ENV'] ||= 'test'

require 'support/simplecov'
require_relative '../config/environment'
require_relative '../config/application'
require_relative '../config/cors'
require File.expand_path('./config/initializers/i18n')
require 'sinatra/activerecord/rake'
require 'support/factory_bot'
require_all 'lib'
require_all 'app'
require 'pry'
require 'vcr'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  Application.load!

  VCR.configure do |vcr_config|
    vcr_config.hook_into :webmock
    vcr_config.cassette_library_dir = 'spec/support/vcr_cassettes'
  end

  # Database setup
  if ActiveRecord::Base.connection.migration_context.needs_migration?
    # Run migrations for test environment
    Rake::Task['db:migrate'].execute
  end

  config.before do |example|
    I18n.locale = example.metadata.fetch(:locale, :'en-US')
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = 'random'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Keep as many of these lines as are necessary:
    with.library :active_record
    with.library :active_model
  end
end

def app
  Application.initialize!
end

def json_body(body)
  JSON.parse(body)
end

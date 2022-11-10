# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'support/simplecov'
require_relative '../config/environment'
require File.expand_path('./config/initializers/i18n')
require 'sinatra/activerecord/rake'
require 'support/factory_bot'
require_all 'app'
require_all 'lib'
require 'pry'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # Database setup
  if ActiveRecord::Base.connection.migration_context.needs_migration?
    # Run migrations for test environment
    Rake::Task['db:migrate'].execute
  end

  config.before do |example|
    I18n.locale = example.metadata.fetch(:locale, :en)
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

# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  factories = [Dir.pwd, 'spec', 'support', 'factories', '**', '*.rb'].join('/')
  Dir[factories].each { |f| require f }
end

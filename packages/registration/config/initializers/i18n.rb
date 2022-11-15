# frozen_string_literal: true

module Location
  SUPPORTED = %i[en pt-BR].freeze

  def self.load
    locales_path = "#{File.expand_path('config/locales')}/**/*.yml"

    I18n.load_path << Dir[locales_path]
    I18n.default_locale = ENV.fetch('LOCATION', :'en-US').to_sym
  end

  def self.define(location)
    location = location&.to_sym

    return I18n.locale = :'en-US' unless SUPPORTED.include?(location)

    I18n.locale = location
  end
end

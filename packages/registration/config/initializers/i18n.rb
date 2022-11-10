# frozen_string_literal: true

locales_path = "#{File.expand_path('config/locales')}/**/*.yml"

I18n.load_path << Dir[locales_path]
I18n.default_locale = ENV.fetch('LOCATION', :en).to_sym

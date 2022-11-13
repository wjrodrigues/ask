# frozen_string_literal: true

module Application
  def self.load!
    require_rel 'initializers'
    require_all 'app'

    Location.load
  end

  def self.initialize!
    require_relative 'routes'

    Routes
  end
end

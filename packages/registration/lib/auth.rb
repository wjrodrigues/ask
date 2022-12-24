# frozen_string_literal: true

module Lib
  class Auth
    TARGETS = { keycloack: 'Lib::Auth::Keycloack' }.freeze
    GET_TARGET = lambda do |target|
      [target] => [Symbol]

      raise NotImplementedError, "#{target} unsupported" unless TARGETS.key?(target)

      TARGETS.fetch(target)
    end

    def self.create(first_name:, last_name:, password:, email:, target:)
      klass = GET_TARGET.call(target).constantize.new
      klass.create(first_name:, last_name:, password:, email:)
    end

    private_constant :TARGETS, :GET_TARGET
  end
end

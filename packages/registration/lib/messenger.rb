# frozen_string_literal: true

module Lib
  class Messenger
    TARGETS = { rabbitmq: 'Lib::Notification::Rabbitmq' }.freeze
    GET_TARGET = lambda do |target|
      [target] => [Symbol]

      raise NotImplementedError, "#{target} unsupported" unless TARGETS.key?(target)

      TARGETS.fetch(target)
    end

    # def self.create(password:, email:, target:, first_name: nil, last_name: nil)
    #   klass = GET_TARGET.call(target).constantize.new
    #   klass.create(first_name:, last_name:, password:, email:)
    # end

    private_constant :TARGETS, :GET_TARGET
  end
end

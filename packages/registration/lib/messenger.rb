# frozen_string_literal: true

module Lib
  class Messenger
    QUEUES = %w[notification.mobile notification.email].freeze
    TARGETS = { rabbitmq: 'Lib::Messenger::Rabbitmq' }.freeze

    TARGET = lambda do |target|
      [target] => [Symbol]

      raise NotImplementedError, "#{target} unsupported" unless TARGETS.key?(target)

      TARGETS.fetch(target).constantize
    end

    CHECK_QUEUE = lambda do |exchange, queue|
      key = "#{exchange}.#{queue}"

      raise NotImplementedError, "#{key} unsupported" unless QUEUES.include?(key)
    end

    def self.publish!(message:, exchange:, queue:, target: :rabbitmq)
      [message] => [String]

      CHECK_QUEUE.call(exchange, queue)

      TARGET.call(target.to_sym).publish(message:, exchange:, queue:)
    end

    private_constant :QUEUES, :TARGETS, :TARGET, :CHECK_QUEUE
  end
end

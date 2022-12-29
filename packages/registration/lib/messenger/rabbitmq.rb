# frozen_string_literal: true

require 'bunny'

module Lib
  # rubocop:disable Style/ClassVars
  class Messenger::Rabbitmq
    @@session = nil

    SESSION = lambda do
      Bunny.new(
        host: ENV.fetch('RABBITMQ_HOST'),
        user: ENV.fetch('RABBITMQ_USER'),
        password: ENV.fetch('RABBITMQ_PASS'),
        vhost: ENV.fetch('RABBITMQ_VHOST'),
        port: ENV.fetch('RABBITMQ_PORT', 5672)
      ).start
    end

    CHECK_SESSION = lambda do
      @@session = SESSION.call if @@session.nil? || !@@session.connected?
    end

    def self.publish(message:, exchange:, queue:)
      CHECK_SESSION.call

      channel = @@session.create_channel
      channel.basic_publish(message, exchange, queue)

      true
    rescue StandardError => e
      Lib::ErrorTracker.notify(e)

      false
    ensure
      channel&.close
    end

    private_constant :SESSION, :CHECK_SESSION
  end
  # rubocop:enable Style/ClassVars
end

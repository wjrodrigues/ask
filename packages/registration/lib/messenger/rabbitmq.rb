# frozen_string_literal: true

module Lib
  # rubocop:disable Style/ClassVars
  class Messenger::Rabbitmq
    @@connection = nil

    INSTANCE = lambda do
      Bunny.new(
        host: ENV.fetch('RABBITMQ_HOST'),
        user: ENV.fetch('RABBITMQ_USER'),
        password: ENV.fetch('RABBITMQ_PASS'),
        vhost: ENV.fetch('RABBITMQ_VHOST'),
        port: ENV.fetch('RABBITMQ_PORT', 5672)
      ).start
    end

    CONNECTION = lambda do
      @@connection = INSTANCE.call if @@connection.nil? || !@@connection.connected?

      @@connection
    end

    def self.publish
      CONNECTION.call
    end

    private_constant :INSTANCE, :CONNECTION
  end
  # rubocop:enable Style/ClassVars
end

# connection = Bunny.new(:host => "message_broker", :user => "producer", :password => "rabbitmq")
# connection.start
# channel = connection.create_channel
# channel.queue('notification')
# channel.default_exchange.publish('Hello World!', routing_key: '')
# puts " [x] Sent 'Hello World!'"

# connection = Bunny.new(:host => "message_broker", :user => "producer", :password => "rabbitmq")
# connection.start
# channel = connection.create_channel
# channel.basic_publish("message2", "notification", "mobile")

# connection = Bunny.new(:host => "message_broker", :user => "consumer", :password => "rabbitmq")
# connection.start
# channel = connection.create_channel
# channel.basic_publish("message2", "notification", "mobile2")

# connection = Bunny.new(:host => "message_broker", :user => "producer", :password => "rabbitmq")
# connection.start
# channel = connection.create_channel
# queue = Bunny::Queue.new(channel, 'mobile', {durable: true})
# queue.subscribe do |delivery_info, properties, payload|
#     channel.basic_ack(delivery_info.delivery_tag.to_i)
#     puts "------"
#     puts payload
#     puts "------"
# end

# connection = Bunny.new(:host => "message_broker", :user => "consumer", :password => "rabbitmq")
# connection.start
# channel = connection.create_channel
# queue = Bunny::Queue.new(channel, 'mobil3e', {durable: true})
# queue.subscribe do |delivery_info, properties, payload|
#     channel.basic_ack(delivery_info.delivery_tag.to_i)
#     puts "------"
#     puts payload
#     puts "------"
# end
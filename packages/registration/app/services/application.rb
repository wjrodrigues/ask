# frozen_string_literal: true

module Service
  class Application
    attr_reader :response

    def self.call(*args, &block)
      new(*args, &block).call
    end

    private

    attr_writer :response

    private_class_method :new

    def initialize
      self.response = Service::Response.new

      super
    end
  end
end

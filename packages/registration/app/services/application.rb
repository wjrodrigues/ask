# frozen_string_literal: true

module Service
  class Application
    attr_reader :response

    def self.call(**args, &)
      new(**args, &).call
    end

    private

    attr_writer :response

    private_class_method :new

    def initialize(*_)
      self.response = Service::Response.new
    end
  end
end

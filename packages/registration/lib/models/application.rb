# frozen_string_literal: true

module Model
  class Application
    attr_reader :response

    def self.call(...)
      new(...).call
    end

    private

    attr_writer :response

    private_class_method :new

    def initialize(*_)
      self.response = Model::Response.new
    end
  end
end

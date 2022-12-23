# frozen_string_literal: true

require 'rest-client'

module Lib
  class Request
    TIMEOUT = 20 # seconds

    def self.execute(url, args = {})
      RestClient::Request.execute(url:, timeout: TIMEOUT, **args)
    rescue ArgumentError, Errno::EADDRNOTAVAIL => e
      raise StandardError, e.message
    rescue StandardError => e
      raise Lib::HttpError.new(response: e.response)
    end

    private_constant :TIMEOUT
  end

  class HttpError < StandardError
    attr_reader :response

    def initialize(response: nil)
      @response = response

      super
    end
  end
end

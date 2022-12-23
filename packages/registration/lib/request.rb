# frozen_string_literal: true

require 'rest-client'

module Lib
  class Request
    TIMEOUT = 20 # seconds

    def self.execute(url, args = {})
      RestClient::Request.execute(url:, timeout: TIMEOUT, **args)
    rescue StandardError => e
      raise Lib::HttpError, e
    end

    private_constant :TIMEOUT
  end

  class HttpError < StandardError; end
end

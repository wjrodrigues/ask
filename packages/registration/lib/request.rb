# frozen_string_literal: true

require 'http'

module Lib
  class Request
    TIMEOUT = 30 # seconds

    DEFAULT = -> { HTTP.timeout(TIMEOUT) }

    def self.get(*args)
      DEFAULT.call.get(*args)
    rescue StandardError => e
      raise Lib::HttpError e
    end

    def self.post(*args)
      DEFAULT.call.post(*args)
    rescue StandardError => e
      raise Lib::HttpError e
    end

    private_constant :DEFAULT, :TIMEOUT
  end

  class HttpError < StandardError; end
end

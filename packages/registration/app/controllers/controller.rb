# frozen_string_literal: true

module Controller
  class Base < Sinatra::Base
    def self.body(request)
      return JSON.parse(request.body.read) if json?(request)

      request.body.read
    end

    def self.json?(request)
      request.env['CONTENT_TYPE'] == 'application/json'
    end
  end
end

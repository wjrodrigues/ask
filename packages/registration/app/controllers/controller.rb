# frozen_string_literal: true
require 'sinatra/cross_origin'

module Controller
  class Base < Sinatra::Base
    set :bind, '0.0.0.0'

    configure do
      enable :cross_origin
    end

    def self.body(request)
      return JSON.parse(request.body.read) if json?(request)

      request.body.read
    end

    def self.json?(request)
      request.env['CONTENT_TYPE'] == 'application/json'
    end
  end
end

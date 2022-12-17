# frozen_string_literal: true

module Cors
  def self.allow(response)
    response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept'
    response.headers['Access-Control-Allow-Origin'] = '*'

    200
  end
end

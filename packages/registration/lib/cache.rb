# frozen_string_literal: true

require 'redis'

module Lib
  class Cache
    REDIS = lambda do
      Redis.new(
        host: ENV.fetch('CACHE_HOST'),
        port: ENV.fetch('CACHE_PORT'),
        db: ENV.fetch('CACHE_DATABASE'),
        password: ENV.fetch('CACHE_PASSWORD')
      )
    end

    VALID_RESPONSE = lambda do |value|
      [value] => [Hash | String | Integer | Array | NilClass]

      true
    end

    private_constant :REDIS

    def self.fetch(key, expires_in: nil, &block)
      in_memory = REDIS.call.get(key)
      # rubocop:disable Security/MarshalLoad
      return Marshal.load(in_memory) unless in_memory.nil?
      # rubocop:enable Security/MarshalLoad

      cache_response = yield unless block.nil?
      VALID_RESPONSE.call(cache_response)

      return cache_response if cache_response.nil?

      REDIS.call.set(key, Marshal.dump(cache_response), ex: expires_in)

      cache_response
    end
  end
end

# frozen_string_literal: true

module Controller
  class Response
    REASONS = {
      OK: 200,
      CREATED: 201,
      ACCEPTED: 202,
      NO_CONTENT: 204,
      MOVED_PERMANENTLY: 301,
      FOUND: 302,
      NOT_MODIFIED: 304,
      BAD_REQUEST: 400,
      UNAUTHORIZED: 401,
      PAYMENT_REQUIRED: 402,
      FORBIDDEN: 403,
      NOT_FOUND: 404,
      METHOD_NOT_ALLOWED: 405,
      NOT_ACCEPTABLE: 406,
      GONE: 410,
      UNSUPPORTED_MEDIA_TYPE: 415,
      UNPROCESSABLE_ENTITY: 422,
      INTERNAL_SERVER_ERROR: 500,
      NOT_IMPLEMENTED: 501,
      BAD_GATEWAY: 502
    }.freeze

    def call(value)
      return @success if value

      @failure
    end

    def self.success(status:, body: nil, action: nil)
      new.success(status:, body:, action:)
    end

    def success(status:, body: nil, action: nil)
      @success = [REASONS[status], body]

      action&.call

      self
    end

    def self.failure(status:, body: nil, action: nil)
      new.failure(status:, body:, action:)
    end

    def failure(status:, body: nil, action: nil)
      @failure = [REASONS[status], body]

      action&.call

      self
    end
  end
end

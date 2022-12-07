# frozen_string_literal: true

module Controller
  class Token < Controller::Base
    def self.post(request)
      struct = Controller::Request.call(body(request))
      response = ::Token::Creator.call(struct)

      Response.success(status: :CREATED)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end

    def self.validate(request)
      params = body(request)
      params[:code] = request.params['code']

      struct = Controller::Request.call(params)
      response = ::Token::Validator.call(struct)

      Response.success(status: :OK)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end

    def self.burn(request)
      params = body(request)
      params[:code] = request.params['code']

      params = Controller::Request.call(params)
      response = ::Token::Burn.call(params:, validator: ::Token::Validator)

      Response.success(status: :OK)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end
  end
end

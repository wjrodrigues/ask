# frozen_string_literal: true

module Controller
  class Token < Controller::Base
    def self.post(request)
      struct = Controller::Request.call(body(request))
      response = Service::CreatorToken.call(struct)

      Response.success(status: :CREATED)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end

    def self.validate(request)
      params = body(request)
      params[:code] = request.params['code']

      struct = Controller::Request.call(params)
      response = Service::ValidatorToken.call(struct)

      Response.success(status: :OK)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end

    def self.burn(request)
      params = body(request)
      params[:code] = request.params['code']

      params = Controller::Request.call(params)
      response = Service::BurnToken.call(params:, validator: Service::ValidatorToken)

      Response.success(status: :OK)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end
  end
end

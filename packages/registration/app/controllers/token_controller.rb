# frozen_string_literal: true

module Controller
  class Token < Controller::Base
    def self.post(request)
      struct = Controller::Request.call(body(request))
      response = Service::CreatorToken.call(struct)

      return Response.call(:CREATED) if response.ok?

      Response.call(:UNPROCESSABLE_ENTITY, response.errors.to_json)
    end

    def self.validate(request)
      params = body(request)
      params[:code] = request.params['code']

      struct = Controller::Request.call(params)
      response = Service::ValidatorToken.call(struct)

      return Response.call(:OK) if response.ok?

      Response.call(:UNPROCESSABLE_ENTITY, response.errors.to_json)
    end

    def self.burn(request)
      params = body(request)
      params[:code] = request.params['code']

      struct = Controller::Request.call(params)
      response = Service::BurnToken.call(struct, Service::ValidatorToken)

      return Response.call(:OK) if response.ok?

      Response.call(:UNPROCESSABLE_ENTITY, response.errors.to_json)
    end
  end
end

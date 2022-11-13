# frozen_string_literal: true

module Controller
  class User < Controller::Base
    def self.post(request)
      struct = Controller::Request.call(body(request))
      response = Service::CreatorUser.call(struct)

      return Response.call(:CREATED) if response.ok?

      Response.call(:UNPROCESSABLE_ENTITY, response.errors.to_json)
    end
  end
end

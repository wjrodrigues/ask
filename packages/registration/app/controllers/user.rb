# frozen_string_literal: true

module Controller
  class User < Controller::Base
    def self.post(request)
      struct = Controller::Request.call(body(request))
      response = ::User::Creator.call(struct)

      Response.success(status: :CREATED)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end

    def self.patch(request)
      params = body(request)
      params[:id] = request.params['id']

      struct = Controller::Request.call(params)
      response = ::User::Updater.call(struct)

      Response.success(status: :OK)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end

    def self.update_profile(request)
      params = body(request)
      params[:user_id] = request.params['id']

      struct = Controller::Request.call(params)
      response = ::Profile::Updater.call(struct)

      Response.success(status: :OK)
              .failure(status: :UNPROCESSABLE_ENTITY, body: response.errors.to_json)
              .call(response.ok?)
    end
  end
end

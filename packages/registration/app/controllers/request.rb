# frozen_string_literal: true

module Controller
  class Request
    def self.call(params = {})
      return nil if params.empty?

      struct = Struct.new(*params.keys.map(&:to_sym)) do
        # rubocop:disable Lint/MissingRespondToMissing
        def method_missing(method, *_)
          return nil unless respond_to?(method)
        end
        # rubocop:enable Lint/MissingRespondToMissing
      end

      klass = struct.new

      params.map { |key, value| klass[key] = value }

      klass
    end
  end
end

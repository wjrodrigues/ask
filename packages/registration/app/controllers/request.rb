# frozen_string_literal: true

module Controller
  class Request
    def self.call(params = {})
      return nil if params.empty?

      struct = Struct.new(*params.keys.map(&:to_sym)) do
        def method_missing(method, *_)
          return nil unless respond_to?(method)
        end

        def respond_to_missing?(method_name, *args); end
      end

      klass = struct.new

      params.map { |key, value| klass[key] = value }

      klass
    end
  end
end

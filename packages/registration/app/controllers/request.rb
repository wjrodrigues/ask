# frozen_string_literal: true

module Controller
  class Request
    def self.call(params = {})
      return nil if params.empty?

      klass = Struct.new(*params.keys.map(&:to_sym)).new

      params.map { |key, value| klass[key] = value }

      klass
    end
  end
end

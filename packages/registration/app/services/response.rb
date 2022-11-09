# frozen_string_literal: true

module Service
  class Response
    def initialize
      @errors = []
    end

    def add_error(error)
      @errors << error
    end

    def errors
      @errors.clone
    end
  end
end

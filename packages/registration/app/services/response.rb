# frozen_string_literal: true

module Service
  class Response
    attr_reader :result

    def initialize
      @errors = []
      @result = nil
    end

    def add_error(error, translate: true)
      @errors << if translate
                   I18n.t(error)
                 else
                   error
                 end

      self
    end

    def add_result(value)
      @result = value

      self
    end

    def errors
      @errors.clone
    end

    def ok?
      @errors.empty?
    end
  end
end

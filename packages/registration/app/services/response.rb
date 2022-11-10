# frozen_string_literal: true

module Service
  class Response
    def initialize
      @errors = []
    end

    def add_error(error, translate: true)
      @errors << if translate
                   I18n.t(error)
                 else
                   error
                 end

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

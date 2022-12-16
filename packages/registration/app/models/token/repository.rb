# frozen_string_literal: true

module Token
  class Repository
    def self.burn!(user_id:, kind:, code:)
      find(user_id:, kind:, code:).burn!
    rescue StandardError
      raise Token::Invalid
    end

    def self.find(user_id:, kind:, code:)
      ::Token::Record.find_by(user_id:, kind:, code:)
    end

    def self.valid?(user_id:, kind:, code:)
      ::Token::Record.where(user_id:, kind:, code:).exists?
    end

    def self.expired?(user_id:, kind:, code:)
      record = find(user_id:, kind:, code:)

      return record.expired? if record.present?

      true
    end

    def self.used?(user_id:, kind:, code:)
      record = find(user_id:, kind:, code:)

      return record.used? if record.present?

      true
    end
  end
end

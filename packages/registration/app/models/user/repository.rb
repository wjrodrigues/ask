# frozen_string_literal: true

module User
  class Repository
    def self.create(email:, password:)
      Record.create(email:, password:).persisted?
    end

    def self.errors(email:, password:)
      record = Record.new(email:, password:)
      record.valid?

      record.errors.messages
    end

    def self.find(value:)
      record = Record.where(id: value).or(Record.where(email: value)).first

      return nil if record.nil?

      record.serializable_hash.symbolize_keys
    end

    def self.update(id:, email: nil, password: nil)
      record = Record.find_by(id:)

      return false if record.nil?

      record.email = email unless email.nil?
      record.password = password unless password.nil?

      record.save
    end
  end
end

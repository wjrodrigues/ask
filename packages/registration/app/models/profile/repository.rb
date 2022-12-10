# frozen_string_literal: true

module Profile
  class Repository
    def self.update(user_id:, first_name:, last_name: nil, photo: nil)
      record = Record.find_or_create_by(user_id:)
      record.last_name unless last_name.nil?
      record.photo unless photo.nil?

      record.update(first_name:)
    end

    def self.errors(user_id:, first_name:, last_name: nil, photo: nil)
      record = Record.new(user_id:, first_name:, last_name:, photo:)
      record.valid?

      record.errors.messages
    end

    def self.find(id:)
      record = Record.where(id:).or(Record.where(user_id: id)).first
      return nil if record.nil?

      record.serializable_hash.symbolize_keys
    end
  end
end

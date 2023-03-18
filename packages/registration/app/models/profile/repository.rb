# frozen_string_literal: true

module Profile
  class Repository
    def self.update(user_id:, first_name: nil, last_name: nil, photo: nil)
      record = Record.find_or_initialize_by(user_id:)

      record.first_name = first_name unless first_name.nil?
      record.last_name = last_name unless last_name.nil?
      record.photo = photo unless photo.nil?

      record.save
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

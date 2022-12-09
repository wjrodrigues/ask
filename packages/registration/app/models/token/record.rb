# frozen_string_literal: true

module Token
  class Record < ActiveRecord::Base
    self.table_name = 'user_tokens'

    belongs_to :user, class_name: '::User::Record'

    KINDS = { SMS: 'sms', LOGIN: 'login', RESET: 'reset' }.freeze

    validates :code, :kind, :expire_at, presence: true
    validates :kind, inclusion: { in: KINDS.values }

    alias_attribute :used?, :used_at?

    def burn!
      raise ActiveRecord::RecordInvalid unless used_at.nil?

      update!(used_at: DateTime.current)
    end

    def expired?
      expire_at.past?
    end
  end
end

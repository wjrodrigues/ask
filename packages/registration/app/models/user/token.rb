# frozen_string_literal: true

class User::Token < ActiveRecord::Base
  belongs_to :user

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

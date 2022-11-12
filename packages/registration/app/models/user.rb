# frozen_string_literal: true

class User < ActiveRecord::Base
  has_one :profile

  validates :email, :password, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }

  before_save :encrypt_password

  private

  def encrypt_password
    return unless attribute_changed?(:password) || !persisted?

    self.password = password.crypt(ENV.fetch('SECRET_KEY', nil))
  end
end

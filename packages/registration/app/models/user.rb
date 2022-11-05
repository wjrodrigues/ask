# frozen_string_literal: true

class User < ActiveRecord::Base
  has_one :profile

  validates :email, :password, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
end
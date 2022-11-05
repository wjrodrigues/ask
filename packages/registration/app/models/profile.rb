# frozen_string_literal: true

class Profile < ActiveRecord::Base
  belongs_to :user

  validates :first_name, :user, presence: true
end

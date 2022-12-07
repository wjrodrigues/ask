# frozen_string_literal: true

module Profile
  class Record < ActiveRecord::Base
    self.table_name = 'user_profiles'

    belongs_to :user, class_name: '::User::Record'

    validates :first_name, :user, presence: true
  end
end

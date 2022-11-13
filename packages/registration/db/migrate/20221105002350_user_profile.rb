# frozen_string_literal: true

class UserProfile < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: true
      t.string :photo, null: true

      t.timestamps
    end

    add_reference :user_profiles, :user, foreign_key: true, type: :uuid, null: false
  end
end

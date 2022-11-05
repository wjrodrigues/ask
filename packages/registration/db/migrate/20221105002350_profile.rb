# frozen_string_literal: true

class Profile < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: true
      t.string :photo, null: true

      t.timestamps
    end

    add_reference :profiles, :user, foreign_key: true, type: :uuid, null: false
  end
end

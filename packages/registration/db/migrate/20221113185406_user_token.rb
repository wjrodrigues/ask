# frozen_string_literal: true

class UserToken < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tokens, id: :uuid do |t|
      t.string :code, null: false
      t.string :kind, null: false
      t.datetime :expire_at
      t.datetime :used_at, null: true

      t.timestamps
    end

    add_reference :user_tokens, :user, foreign_key: true, type: :uuid, null: false
  end
end

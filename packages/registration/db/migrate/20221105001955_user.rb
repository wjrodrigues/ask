# frozen_string_literal: true

class User < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.text :password, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end

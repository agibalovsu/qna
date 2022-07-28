# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.integer :rating, null: false, default: 0
      t.references :user
      t.belongs_to :likable, polymorphic: true

      t.timestamps
    end
  end
end

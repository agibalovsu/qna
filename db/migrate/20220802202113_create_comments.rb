# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, foreign_key: true
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end

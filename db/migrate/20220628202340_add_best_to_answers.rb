# frozen_string_literal: true

class AddBestToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end

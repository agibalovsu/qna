# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :badges
  has_many :likes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(model)
    id == model.user_id
  end

  def get_reward!(badge)
    badges << badge
  end

  def liked?(item)
    likes.exists?(likable: item)
  end
end


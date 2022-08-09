# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :badges
  has_many :likes
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def author?(model)
    id == model.user_id
  end

  def get_reward!(badge)
    badges << badge
  end

  def liked?(item)
    likes.exists?(likable: item)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end

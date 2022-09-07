# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :badges
  has_many :likes
  has_many :subscriptions, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

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
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['omniauth']
        password = Devise.friendly_token[0, 20]
        user.password = password
        user.password_confirmation = password
      end
    end
  end

  def subscribed?(question)
    subscriptions.where(question_id: question.id).any?
  end
end

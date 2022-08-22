# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer],  user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :destroy, Link,  linkable: { user_id: user.id }
    can :destroy, Badge, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment do |resource|
      user.author?(resource.record)
    end

    can %i[like_up like_down revoke], [Question, Answer] do |likable|
      !user.author?(likable)
    end

    can :best, Answer, question: { user_id: user.id }

    can :me, User
  end
end

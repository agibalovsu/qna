module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likable, dependent: :destroy
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def rating_sum
    likes.sum(:rating)
  end

  private

  def vote(user, rate)
    likes.create!(user: user, rating: rate) unless user.liked?(self)
  end
end
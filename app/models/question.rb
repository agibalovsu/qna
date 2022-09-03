# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy

  has_one :badge, dependent: :destroy

  include Likable
  include Commentable

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create!(user_id: user.id)
  end
end

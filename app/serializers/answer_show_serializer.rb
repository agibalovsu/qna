# frozen_string_literal: true

class AnswerShowSerializer < AnswerSerializer
  belongs_to :user
  belongs_to :question
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end

class QuestionShowSerializer < QuestionSerializer
  
  belongs_to :user
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links

end

class Like < ApplicationRecord
	belongs_to :user
	belongs_to :likable, polymorphic: true, touch: true

	validates :rating, presence: true
	validates_numericality_of :rating, only_integer: true
	validates_inclusion_of :rating, in: -1..1 
end

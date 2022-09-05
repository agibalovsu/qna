# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    value { 1 }
    user
    likable factory: :question
  end
end

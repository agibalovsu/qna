# frozen_string_literal: true

FactoryBot.define do
  sequence :answer_body do |n|
    "Body #{n}"
  end

  factory :answer do
    question
    body 

    trait :invalid do
      question
      body { nil }
    end
  end
end

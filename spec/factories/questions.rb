# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  sequence :body do |n|
    "Body #{n}"
  end

  factory :question do
    title { 'MyString' }
    body { 'MyQuestionText' }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  sequence :body do |n|
    "Body #{n}"
  end

  factory :question do
    title
    body

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end

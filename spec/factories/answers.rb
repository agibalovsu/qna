FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
  

    trait :invalid do 
      question
      body { nil }
    end
  end
end


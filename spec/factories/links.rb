# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'Thinknetica' }
    url { 'http://thinknetica.com' }

    trait :gist_link do
      name { 'Gist' }
      url { 'https://gist.github.com/agibalovsu/1a4a3b58d7b09b08e94cf827a3ee09a2' }
    end
  end
end

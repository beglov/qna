FactoryBot.define do
  factory :answer do
    question
    user
    body { 'MyText' }

    trait :invalid do
      body { nil }
    end
  end
end

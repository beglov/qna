FactoryBot.define do
  factory :comment do
    association :commentable, factory: :question
    user
    body { 'MyText' }

    trait :invalid do
      body { nil }
    end
  end
end

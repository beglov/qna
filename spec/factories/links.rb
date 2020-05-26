FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    name { "MyString" }
    url { "http://foo.com" }
  end
end

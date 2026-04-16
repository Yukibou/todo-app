FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    done { false }
    association :user, factory: :user
  end
end

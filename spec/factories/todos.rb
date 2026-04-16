FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence }
    done { false }
    association :user, factory: :user
  end
end

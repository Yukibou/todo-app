FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    assignee { Faker::Name.name }
    done { false }
    association :user, factory: :user
  end
end

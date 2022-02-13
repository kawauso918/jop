FactoryBot.define do
  factory :photo_image do
    name { Faker::Lorem.characters(number: 5) }
    caption { Faker::Lorem.characters(number: 20) }
    user
  end
end
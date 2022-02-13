FactoryBot.define do
  factory :photo_image do
    name { Faker::Lorem.characters(number:10) }
    caption { Faker::Lorem.characters(number:30) }
  end
  factory :user do
    name { Faker::Lorem.characters(number:10) }
    caption { Faker::Lorem.characters(number:30) }
  end
end
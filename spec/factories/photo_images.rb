FactoryBot.define do
  factory :photo_image do
    name { Faker::Lorem.characters(number: 5) }
    caption { Faker::Lorem.characters(number: 20) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/karina-vorozheeva-rW-I87aPY5Y-unsplash.jpg')) }
    user
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :profile, class: '::Profile::Record' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    user

    trait :photo do
      photo { '/profile.jpg' }
    end
  end
end

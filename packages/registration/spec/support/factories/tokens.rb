# frozen_string_literal: true

FactoryBot.define do
  factory :user_token, class: '::Token::Record' do
    user
    code { Faker::Alphanumeric.alphanumeric(number: 30) }
    kind { :reset }
    expire_at { 24.hours.from_now }

    trait :sms do
      code { Faker::Alphanumeric.alphanumeric(number: 6) }
      kind { :sms }
    end

    trait :expired do
      expire_at { 1.day.ago }
    end

    trait :burned do
      used_at { DateTime.current }
    end
  end
end

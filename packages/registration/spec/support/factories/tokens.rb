# frozen_string_literal: true

FactoryBot.define do
  factory :user_token, class: 'User::Token' do
    user
    code { Faker::Alphanumeric.alphanumeric(number: 30) }
    kind { :reset }
    expire_at { 24.hours.from_now }

    trait :sms do
      code { Faker::Alphanumeric.alphanumeric(number: 6) }
      kind { :sms }
    end
  end
end

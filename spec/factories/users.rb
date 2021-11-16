# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Internet.name }
    username { Faker::Internet.username }
    email_address { Faker::Internet.email }
    sso_uid { Faker::Number.unique.number.to_s }
    role { 'regular_user' }
  end
end

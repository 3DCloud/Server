# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username }
    email_address { Faker::Internet.email }
    sso_uid { '1771' }
    role { 'regular_user' }
  end
end

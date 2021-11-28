# frozen_string_literal: true

FactoryBot.define do
  factory :cancellation_reason do
    name { Faker::FunnyName.unique.name }
    description { 'The printer did a boo boo' }
  end
end

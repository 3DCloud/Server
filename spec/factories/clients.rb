# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    id { SecureRandom.uuid }
    name { Faker::Games::DnD.monster }
    secret { SecureRandom.base64(36) }
  end
end

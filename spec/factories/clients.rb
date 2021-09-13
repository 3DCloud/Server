# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    id { SecureRandom.uuid }
    name { Faker::Games::DnD.monster }
    secret { SecureRandom.urlsafe_base64(36) }
    authorized { true }
  end
end

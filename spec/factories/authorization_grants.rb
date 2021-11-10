# frozen_string_literal: true

FactoryBot.define do
  factory :authorization_grant do
    association :user
    code_challenge { Digest::SHA2.new(256).hexdigest(Faker::String.random) }
    authorization_code { SecureRandom.hex(32) }
    expires_at { DateTime.now.utc + 1.minute }
  end
end

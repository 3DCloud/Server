# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user
    jti { SecureRandom.hex(32) }
    expires_at { DateTime.now.utc + 10.minutes }
    created_at { DateTime.now.utc - 15.minutes }
    updated_at { DateTime.now.utc - 10.minutes }
  end
end

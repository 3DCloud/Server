# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    association :client
    device_name { Faker::Games::Pokemon.unique.name }
    hardware_identifier { SecureRandom.uuid }
    is_portable_hardware_identifier { true }
    last_seen { DateTime.now.utc }
  end
end

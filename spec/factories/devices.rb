# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    association :client
    name { Faker::Games::Pokemon.unique.name }
    path { 'some/device/path' }
    serial_number { nil }
    last_seen { DateTime.now.utc }
  end
end

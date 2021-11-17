# frozen_string_literal: true

FactoryBot.define do
  factory :printer do
    association :device
    association :printer_definition
    name { Faker::Games::ElderScrolls.unique.creature }
    state { 'ready' }
  end
end

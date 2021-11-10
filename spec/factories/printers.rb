# frozen_string_literal: true

FactoryBot.define do
  factory :printer do
    association :device
    association :printer_definition
    name { Faker::Games::ElderScrolls.creature }
    state { 'ready' }
  end
end

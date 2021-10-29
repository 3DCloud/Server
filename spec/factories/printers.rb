# frozen_string_literal: true

FactoryBot.define do
  factory :printer do
    device
    printer_definition
    name { Faker::Games::ElderScrolls.creature }
    state { 'ready' }
  end
end

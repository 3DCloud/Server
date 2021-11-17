# frozen_string_literal: true

FactoryBot.define do
  factory :material do
    sequence(:name) { |n| "PLA#{n}" }
    brand { 'Generic' }
    filament_diameter { 2.85 }
    net_filament_weight { 1000 }
    empty_spool_weight { 285 }
  end
end

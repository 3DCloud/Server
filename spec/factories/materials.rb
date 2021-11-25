# frozen_string_literal: true

FactoryBot.define do
  factory :material do
    sequence(:name) { |n| "PLA#{n}" }
    brand { 'Generic' }
    net_filament_weight { 1000 }
    empty_spool_weight { 285 }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :material do
    name { 'PLA' }
    brand { 'Generic' }
    filament_diameter { 1.75 }
    net_filament_weight { 1000 }
    empty_spool_weight { 285 }
  end
end

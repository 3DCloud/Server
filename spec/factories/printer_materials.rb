# frozen_string_literal: true

FactoryBot.define do
  factory :printer_material do
    printer { build(:printer) }
    material { build(:material) }
    extruder_index { 0 }
  end
end

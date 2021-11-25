# frozen_string_literal: true

FactoryBot.define do
  factory :printer_extruder do
    association :printer
    association :material_color
    extruder_index { 0 }
    ulti_g_code_nozzle_size { 'size_0_40' }
  end
end

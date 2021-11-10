# frozen_string_literal: true

FactoryBot.define do
  factory :ulti_g_code_settings do
    association :printer_definition
    association :material

    build_plate_temperature { 60 }
    end_of_print_retraction_length { 20 }
    hotend_temperature_0_25 { 190 }
    retraction_length_0_25 { 2.5 }
    retraction_speed_0_25 { 25 }
    hotend_temperature_0_40 { 200 }
    retraction_length_0_40 { 4.0 }
    retraction_speed_0_40 { 40 }
    hotend_temperature_0_60 { 210 }
    retraction_length_0_60 { 6.0 }
    retraction_speed_0_60 { 60 }
    hotend_temperature_0_80 { 220 }
    retraction_length_0_80 { 8.0 }
    retraction_speed_0_80 { 80 }
    hotend_temperature_1_00 { 230 }
    retraction_length_1_00 { 10.0 }
    retraction_speed_1_00 { 100 }
    fan_speed { 100 }
    flow_rate { 100 }
  end
end

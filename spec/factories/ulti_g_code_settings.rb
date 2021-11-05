# frozen_string_literal: true

FactoryBot.define do
  factory :ulti_g_code_settings do
    printer { build(:printer) }
    hotend_temperature { 210 }
    build_plate_temperature { 60 }
    retraction_length { 6.5 }
    end_of_print_retraction_length { 20 }
    retraction_speed { 25 }
    fan_speed { 100 }
    flow_rate { 100 }
  end
end

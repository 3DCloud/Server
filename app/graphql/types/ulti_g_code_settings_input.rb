# frozen_string_literal: true

module Types
  class UltiGCodeSettingsInput < Types::BaseInputObject
    argument :id, ID, required: false
    argument :printer_definition_id, ID, required: false
    argument :material_id, ID, required: true
    argument :build_plate_temperature, Int, required: true
    argument :end_of_print_retraction_length, Float, required: true
    argument :fan_speed, Int, required: true
    argument :flow_rate, Int, required: true
    argument :per_nozzle_settings, PerNozzleSettingsInput, required: true
  end
end

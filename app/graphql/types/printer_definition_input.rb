# frozen_string_literal: true

module Types
  class PrinterDefinitionInput < Types::BaseInputObject
    argument :name, String, required: true
    argument :extruder_count, Int, required: true
    argument :g_code_settings, GCodeSettingsInput, required: false
    argument :ulti_g_code_settings, [UltiGCodeSettingsInput], required: false
  end
end

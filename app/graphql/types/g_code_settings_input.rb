# frozen_string_literal: true

module Types
  class GCodeSettingsInput < Types::BaseInputObject
    argument :id, ID, required: false
    argument :start_g_code, String, required: false
    argument :end_g_code, String, required: false
    argument :cancel_g_code, String, required: false
  end
end

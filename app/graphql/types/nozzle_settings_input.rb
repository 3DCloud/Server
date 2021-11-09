# frozen_string_literal: true

module Types
  class NozzleSettingsInput < Types::BaseInputObject
    argument :hotend_temperature, Int, required: true
    argument :retraction_length, Float, required: true
    argument :retraction_speed, Float, required: true
  end
end

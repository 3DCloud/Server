# frozen_string_literal: true

module Types
  class PerNozzleSettingsInput < Types::BaseInputObject
    argument :size_0_25, NozzleSettingsInput, required: true
    argument :size_0_40, NozzleSettingsInput, required: true
    argument :size_0_60, NozzleSettingsInput, required: true
    argument :size_0_80, NozzleSettingsInput, required: true
    argument :size_1_00, NozzleSettingsInput, required: true
  end
end

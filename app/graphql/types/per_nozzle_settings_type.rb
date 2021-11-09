# frozen_string_literal: true

module Types
  class PerNozzleSettingsType < Types::BaseObject
    field :size_0_25, NozzleSettingsType, null: false
    field :size_0_40, NozzleSettingsType, null: false
    field :size_0_60, NozzleSettingsType, null: false
    field :size_0_80, NozzleSettingsType, null: false
    field :size_1_00, NozzleSettingsType, null: false
  end
end

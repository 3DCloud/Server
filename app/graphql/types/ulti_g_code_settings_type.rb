# frozen_string_literal: true

module Types
  class UltiGCodeSettingsType < Types::BaseObject
    field :id, ID, null: false
    field :printer_definition, PrinterDefinitionType, null: false
    field :printer_definition_id, ID, null: false
    field :material, MaterialType, null: false
    field :material_id, ID, null: false
    field :build_plate_temperature, Int, null: false
    field :end_of_print_retraction_length, Float, null: false
    field :per_nozzle_settings, PerNozzleSettingsType, null: false
    field :fan_speed, Int, null: false
    field :flow_rate, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def per_nozzle_settings
      {
        size_0_25: {
          hotend_temperature: object.hotend_temperature_0_25,
          retraction_length: object.retraction_length_0_25,
          retraction_speed: object.retraction_speed_0_25,
        },
        size_0_40: {
          hotend_temperature: object.hotend_temperature_0_40,
          retraction_length: object.retraction_length_0_40,
          retraction_speed: object.retraction_speed_0_40,
        },
        size_0_60: {
          hotend_temperature: object.hotend_temperature_0_60,
          retraction_length: object.retraction_length_0_60,
          retraction_speed: object.retraction_speed_0_60,
        },
        size_0_80: {
          hotend_temperature: object.hotend_temperature_0_80,
          retraction_length: object.retraction_length_0_80,
          retraction_speed: object.retraction_speed_0_80,
        },
        size_1_00: {
          hotend_temperature: object.hotend_temperature_1_00,
          retraction_length: object.retraction_length_1_00,
          retraction_speed: object.retraction_speed_1_00,
        }
      }
    end
  end
end

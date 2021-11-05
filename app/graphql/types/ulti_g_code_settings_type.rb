# frozen_string_literal: true

module Types
  class UltiGCodeSettingsType < Types::BaseObject
    field :id, ID, null: false
    field :printer_definition, PrinterDefinitionType, null: false
    field :printer_definition_id, ID, null: false
    field :material, MaterialType, null: false
    field :material_id, ID, null: false
    field :hotend_temperature, Int, null: false
    field :build_plate_temperature, Int, null: false
    field :retraction_length, Float, null: false
    field :end_of_print_retraction_length, Float, null: false
    field :retraction_speed, Float, null: false
    field :fan_speed, Int, null: false
    field :flow_rate, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

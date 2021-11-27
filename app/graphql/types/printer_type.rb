# frozen_string_literal: true

module Types
  class PrinterType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :state, String, null: false
    field :progress, Float, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :device_id, ID, null: true
    field :device, DeviceType, null: true
    field :printer_definition_id, ID, null: false
    field :printer_definition, PrinterDefinitionType, null: false
    field :printer_extruders, [PrinterExtruderType, null: true], null: false
    field :current_print_id, ID, null: true
    field :current_print, PrintType, null: true
    field :g_code_settings, GCodeSettingsType, null: true
    field :ulti_g_code_settings, [UltiGCodeSettingsType, null: true], null: false
  end
end

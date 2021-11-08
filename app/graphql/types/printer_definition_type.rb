# frozen_string_literal: true

module Types
  class PrinterDefinitionType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :extruder_count, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :driver, String, null: false
    field :g_code_settings, GCodeSettingsType, null: true
    field :ulti_g_code_settings, [UltiGCodeSettingsType], null: false
    field :materials, [MaterialType], null: false
  end
end

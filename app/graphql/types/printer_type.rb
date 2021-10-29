# frozen_string_literal: true

module Types
  class PrinterType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :state, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :device_id, ID, null: false
    field :device, DeviceType, null: false
    field :printer_definition_id, ID, null: false
    field :printer_definition, PrinterDefinitionType, null: false
    field :current_print_id, ID, null: true
    field :current_print, PrintType, null: true
  end
end

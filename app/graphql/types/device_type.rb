# frozen_string_literal: true

module Types
  class DeviceType < Types::BaseObject
    field :id, ID, null: false
    field :device_name, String, null: false
    field :hardware_identifier, String, null: false
    field :is_portable_hardware_identifier, Boolean, null: false
    field :last_seen, GraphQL::Types::ISO8601DateTime, null: false
    field :client_id, ID, null: false
    field :client, ClientType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :printer, PrinterType, null: true
  end
end

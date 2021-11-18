# frozen_string_literal: true

module Types
  class DeviceType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :path, String, null: false
    field :serial_number, String, null: true
    field :last_seen, GraphQL::Types::ISO8601DateTime, null: false
    field :client_id, ID, null: false
    field :client, ClientType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :printer, PrinterType, null: true
  end
end

module Types
  class PrinterType < Types::BaseObject
    field :id, ID, null: false
    field :device_id, String, null: false
    field :name, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :client_id, Integer, null: false
    field :client, Types::ClientType, null: false
    field :printer_definition_id, Integer, null: false
    field :printer_definition, Types::PrinterDefinitionType, null: false
  end
end
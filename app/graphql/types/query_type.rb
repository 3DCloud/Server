# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :clients, [Types::ClientType], null: false
    field :devices, [Types::DeviceType], null: false
    field :printers, [Types::PrinterType], null: false
    field :printer_definitions, [Types::PrinterDefinitionType], null: false

    field :client, Types::ClientType, null: true do
      argument :id, Integer, required: true
    end

    field :device, Types::DeviceType, null: true do
      argument :id, Integer, required: true
    end

    field :printer, Types::PrinterType, null: true do
      argument :id, Integer, required: true
    end

    field :printer_definition, Types::PrinterDefinitionType, null: true do
      argument :id, Integer, required: true
    end

    def clients
      Client.all
    end

    def client(id:)
      Client.find_by_id(id)
    end

    def devices
      Device.all
    end

    def device(id:)
      Device.find_by_id(id)
    end

    def printers
      Printer.all
    end

    def printer(id:)
      Printer.find_by_id(id)
    end

    def printer_definitions
      PrinterDefinition.all
    end

    def printer_definition(id:)
      PrinterDefinition.find_by_id(id)
    end
  end
end

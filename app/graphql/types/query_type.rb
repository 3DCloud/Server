# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::UserType, null: false
    field :clients, [Types::ClientType], null: false
    field :devices, [Types::DeviceType], null: false
    field :printers, [Types::PrinterType], null: false
    field :printer_definitions, [Types::PrinterDefinitionType], null: false
    field :prints, [Types::PrintType], null: false

    field :client, Types::ClientType, null: true do
      argument :id, ID, required: true
    end

    field :device, Types::DeviceType, null: true do
      argument :id, ID, required: true
    end

    field :printer, Types::PrinterType, null: true do
      argument :id, ID, required: true
    end

    field :printer_definition, Types::PrinterDefinitionType, null: true do
      argument :id, ID, required: true
    end

    field :print, Types::PrintType, null: true do
      argument :id, ID, required: true
    end

    field :get_file_download_url, String, null: false do
      argument :id, ID, required: true
    end

    def current_user
      context[:current_user]
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

    def prints
      Print.all.order(created_at: :desc)
    end

    def print(id:)
      Print.find_by_id(id)
    end

    def get_file_download_url(id:)
      UploadedFile.find_by!(id: id, user_id: context[:current_user].id).file.url
    end
  end
end

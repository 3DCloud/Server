# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::UserType, null: false
    field :clients, [Types::ClientType], null: false
    field :devices, [Types::DeviceType], null: false
    field :printers, [Types::PrinterType], null: false
    field :printer_definitions, [Types::PrinterDefinitionType], null: false
    field :prints, [Types::PrintType], null: false

    field :uploaded_files, [Types::UploadedFileType], null: false do
      argument :before, GraphQL::Types::ISO8601DateTime, required: false
    end

    field :uploaded_file, Types::UploadedFileType, null: true do
      argument :id, ID, required: true
    end

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
      Client.order(:name, :id).all
    end

    def client(id:)
      Client.find_by(id: id)
    end

    def devices
      Device.order(:hardware_identifier).all
    end

    def device(id:)
      Device.find_by(id: id)
    end

    def uploaded_files(before: DateTime.now.utc)
      UploadedFile.where(user: context[:current_user], created_at: ..before).order(created_at: :desc).limit(100)
    end

    def uploaded_file(id:)
      UploadedFile.find_by(id: id)
    end

    def printers
      Printer.order(:name).all
    end

    def printer(id:)
      Printer.find_by(id: id)
    end

    def printer_definitions
      PrinterDefinition.order(:name).all
    end

    def printer_definition(id:)
      PrinterDefinition.find_by(id: id)
    end

    def prints
      Print.includes(:printer, uploaded_file: { file_attachment: :blob }).order(created_at: :desc)
    end

    def print(id:)
      Print.find_by(id: id)
    end
  end
end

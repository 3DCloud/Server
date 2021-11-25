# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::UserType, null: true
    field :current_ability, [Types::RuleType], null: false
    field :clients, [Types::ClientType], null: false
    field :devices, [Types::DeviceType], null: false
    field :printers, [Types::PrinterType], null: false do
      argument :state, [String], required: false
    end
    field :printer_definitions, [Types::PrinterDefinitionType], null: false
    field :prints, [Types::PrintType], null: false
    field :materials, [Types::MaterialType], null: false
    field :material_colors, [Types::MaterialColorType], null: false

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

    field :material, Types::MaterialType, null: true do
      argument :id, ID, required: true
    end

    field :get_file_download_url, String, null: false do
      argument :id, ID, required: true
    end

    def current_user
      context[:current_user]
    end

    def current_ability
      context[:current_ability]&.to_list
    end

    def clients
      authorize!(:index, Client)
      Client.order(:name, :id).accessible_by(context[:current_ability]).all
    end

    def client(id:)
      Client.find_by(id: id)
    end

    def devices
      authorize!(:index, Device)
      Device.order(:hardware_identifier).accessible_by(context[:current_ability]).all
    end

    def device(id:)
      Device.find_by(id: id)
    end

    def materials(only_with_colors: true)
      authorize!(:index, Material)
      query = Material.accessible_by(context[:current_ability])
      if only_with_colors
        query = query.joins('INNER JOIN "material_colors" ON "material_colors"."material_id" = "materials"."id"').distinct
      end
      query.order(:name, :brand).all
    end

    def material_colors
      authorize!(:index, MaterialColor)
      MaterialColor.accessible_by(context[:current_ability]).order(:name).all
    end

    def material(id:)
      Material.find_by(id: id)
    end

    def uploaded_files(before: DateTime.now.utc)
      authorize!(:index, UploadedFile)
      UploadedFile.where(created_at: ..before).accessible_by(context[:current_ability]).order(created_at: :desc).limit(100)
    end

    def uploaded_file(id:)
      UploadedFile.find_by(id: id)
    end

    def printers(state: nil)
      authorize!(:index, Printer)
      query = Printer.accessible_by(context[:current_ability])

      if state.present?
        query = query.where(state: state)
      end

      query.order(:name).all
    end

    def printer(id:)
      Printer.find_by(id: id)
    end

    def printer_definitions
      authorize!(:index, PrinterDefinition)
      PrinterDefinition.accessible_by(context[:current_ability]).order(:name).all
    end

    def printer_definition(id:)
      PrinterDefinition.find_by(id: id)
    end

    def prints
      authorize!(:index, Print)
      Print.includes(:printer, uploaded_file: { file_attachment: :blob }).accessible_by(context[:current_ability]).order(created_at: :desc)
    end

    def print(id:)
      Print.find_by(id: id)
    end
  end
end

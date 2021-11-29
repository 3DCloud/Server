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
    field :prints, [Types::PrintType], null: false do
      argument :search, String, required: false
      argument :order_by, String, required: false
      argument :ascending, Boolean, required: false
      argument :statuses, [String], required: false
    end
    field :materials, [Types::MaterialType], null: false
    field :material_colors, [Types::MaterialColorType], null: false
    field :cancellation_reasons, [Types::CancellationReasonType], null: false
    field :cancellation_reason, Types::CancellationReasonType, null: true do
      argument :id, ID, required: true
    end

    field :uploaded_files, [Types::UploadedFileType], null: false do
      argument :before, GraphQL::Types::ISO8601DateTime, required: false
      argument :search, String, required: false
      argument :order_by, String, required: false
      argument :ascending, Boolean, required: false
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
      Device.accessible_by(context[:current_ability]).all
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

    def uploaded_files(before: DateTime.now.utc, search: nil, order_by: nil, ascending: true)
      authorize!(:index, UploadedFile)
      query = UploadedFile.accessible_by(context[:current_ability]).where(created_at: ..before)

      if order_by.present?
        query = query.order([[order_by.to_sym, ascending ? :asc : :desc]].to_h)
      end

      if search.present?
        search = search.downcase
        query = query.where('LOWER("uploaded_files"."filename") LIKE ?', "%#{search}%")
      end

      query.all
    end

    def uploaded_file(id:)
      UploadedFile.find_by(id: id)
    end

    def printers(state: nil)
      authorize!(:index, Printer)
      printers = Printer.accessible_by(context[:current_ability]).order(:name).all

      if state.present?
        printers = printers.select { |printer| state.include?(printer.state) }
      end

      printers
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

    def prints(search: nil, order_by: 'started_at', ascending: false, statuses: nil)
      authorize!(:index, Print)

      order_by = '"uploaded_file"."filename"' if order_by == 'filename'
      order_by = '"printers"."name"' if order_by == 'printer'

      # TODO: not using accessible_by is kinda wonky
      query = Print.joins(:printer, :uploaded_file)
                   .includes(:printer, uploaded_file: { file_attachment: :blob })
                   .where(uploaded_file: { user_id: context[:current_user].id })
                   .order([[order_by.to_sym, ascending ? :asc : :desc]].to_h)

      if search.present?
        search = search.downcase
        query = query.where('LOWER("uploaded_file"."filename") LIKE ?', "%#{search}%").or(Print.where('LOWER("printers"."name") LIKE ?', "%#{search}%"))
      end

      if statuses.present?
        query = query.where(status: statuses)
      end

      query.all
    end

    def print(id:)
      Print.find_by(id: id)
    end

    def cancellation_reasons
      CancellationReason.accessible_by(context[:current_ability]).order(:name).all
    end

    def cancellation_reason(id:)
      CancellationReason.accessible_by(context[:current_ability]).find_by(id: id)
    end
  end
end

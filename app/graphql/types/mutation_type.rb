# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_printer, mutation: Mutations::UpdatePrinter
    field :change_material, mutation: Mutations::ChangeMaterial
    field :delete_material, mutation: Mutations::DeleteMaterial
    field :update_material, mutation: Mutations::UpdateMaterial
    field :create_material, mutation: Mutations::CreateMaterial
    field :delete_uploaded_file, mutation: Mutations::DeleteUploadedFile
    field :reassign_printer, mutation: Mutations::ReassignPrinter
    field :delete_printer_definition, mutation: Mutations::DeletePrinterDefinition
    field :create_printer_definition, mutation: Mutations::CreatePrinterDefinition
    field :update_printer_definition, mutation: Mutations::UpdatePrinterDefinition
    field :cancel_current_print, mutation: Mutations::CancelCurrentPrint
    field :generate_web_socket_ticket, mutation: Mutations::GenerateWebSocketTicket
    field :start_print, mutation: Mutations::StartPrint
    field :record_file_uploaded, mutation: Mutations::RecordFileUploaded
    field :create_upload_file_request, mutation: Mutations::CreateUploadFileRequest
    field :set_client_name, mutation: Mutations::SetClientName
    field :grant_client_authorization, mutation: Mutations::GrantClientAuthorization
    field :revoke_client_authorization, mutation: Mutations::RevokeClientAuthorization
    field :delete_client, mutation: Mutations::DeleteClient
    field :create_printer, mutation: Mutations::CreatePrinter
    field :delete_printer, mutation: Mutations::DeletePrinter
    field :reconnect_printer, mutation: Mutations::ReconnectPrinter
  end
end

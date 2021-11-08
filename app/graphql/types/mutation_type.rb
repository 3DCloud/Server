# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :delete_uploaded_file, mutation: Mutations::DeleteUploadedFile
    field :reassign_printer, mutation: Mutations::ReassignPrinter
    field :delete_printer_definition, mutation: Mutations::DeletePrinterDefinition
    field :create_printer_definition, mutation: Mutations::CreatePrinterDefinition
    field :update_printer_definition, mutation: Mutations::UpdatePrinterDefinition
    field :cancel_current_print, mutation: Mutations::CancelCurrentPrintMutation
    field :generate_web_socket_ticket, mutation: Mutations::GenerateWebSocketTicketMutation
    field :start_print, mutation: Mutations::StartPrintMutation
    field :record_file_uploaded, mutation: Mutations::RecordFileUploaded
    field :create_upload_file_request, mutation: Mutations::CreateUploadFileRequest
    field :set_client_name, mutation: Mutations::SetClientNameMutation
    field :grant_client_authorization, mutation: Mutations::GrantClientAuthorizationMutation
    field :revoke_client_authorization, mutation: Mutations::RevokeClientAuthorizationMutation
    field :delete_client, mutation: Mutations::DeleteClientMutation
    field :create_printer, mutation: Mutations::CreatePrinterMutation
    field :delete_printer, mutation: Mutations::DeletePrinterMutation
    field :reconnect_printer, mutation: Mutations::ReconnectPrinterMutation
  end
end

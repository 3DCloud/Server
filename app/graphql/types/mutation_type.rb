# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :set_client_name, mutation: Mutations::SetClientNameMutation
    field :grant_client_authorization, mutation: Mutations::GrantClientAuthorizationMutation
    field :revoke_client_authorization, mutation: Mutations::RevokeClientAuthorizationMutation
    field :delete_client, mutation: Mutations::DeleteClientMutation
    field :create_printer, mutation: Mutations::CreatePrinterMutation
    field :delete_printer, mutation: Mutations::DeletePrinterMutation
    field :reconnect_printer, mutation: Mutations::ReconnectPrinterMutation
  end
end

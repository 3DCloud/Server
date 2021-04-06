# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :accept_client, mutation: Mutations::AcceptClientMutation
    field :create_printer, mutation: Mutations::CreatePrinterMutation
  end
end

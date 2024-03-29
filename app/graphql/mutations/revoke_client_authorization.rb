# frozen_string_literal: true

module Mutations
  class RevokeClientAuthorization < BaseMutation
    argument :id, ID, required: true

    type Types::ClientType

    def resolve(id:)
      client = Client.find(id)

      authorize!(:update, client)

      client.authorized = false
      client.save!

      ActionCable.server.remote_connections.where(client: client, user: nil).disconnect

      client
    end
  end
end

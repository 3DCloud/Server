# frozen_string_literal: true

module Mutations
  class RevokeClientAuthorizationMutation < BaseMutation
    argument :id, ID, required: true

    type Types::ClientType

    def resolve(id:)
      client = Client.find(id)
      client.authorized = false
      client.save!

      ActionCable.server.remote_connections.where(client: client, user: nil).disconnect

      client
    end
  end
end

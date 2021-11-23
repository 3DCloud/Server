# frozen_string_literal: true

module Mutations
  class DeleteClient < BaseMutation
    argument :id, ID, required: true

    type Types::ClientType

    def resolve(id:)
      client = Client.find(id)
      authorize!(:delete, client)
      client.destroy!

      connection = ActionCable.server.remote_connections.where(client: client, user: nil)
      connection.disconnect unless connection.nil?

      client
    end
  end
end

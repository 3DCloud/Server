# frozen_string_literal: true

module Mutations
  class DeleteClient < BaseMutation
    argument :id, ID, required: true

    field :delete_count, Int, null: false

    def resolve(id:)
      client = Client.find(id)
      client.destroy!

      connection = ActionCable.server.remote_connections.where(client: client, user: nil)
      connection.disconnect unless connection.nil?

      { delete_count: 1 }
    end
  end
end

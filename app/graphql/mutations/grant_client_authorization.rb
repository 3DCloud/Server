# frozen_string_literal: true

module Mutations
  class GrantClientAuthorization < BaseMutation
    argument :id, ID, required: true

    type Types::ClientType

    def resolve(id:)
      client = Client.find(id)

      authorize!(:update, client)

      client.authorized = true
      client.save!
      client
    end
  end
end

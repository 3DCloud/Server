# frozen_string_literal: true

module Mutations
  class AcceptClientMutation < BaseMutation
    argument :id, String, required: true

    type Types::ClientType

    def resolve(id:)
      client = Client.find(id)
      client.authorized = true
      client.save!
      client
    end
  end
end

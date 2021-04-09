module Mutations
  class SetClientName < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false

    type Types::ClientType

    def resolve(id:, name:)
      client = Client.find(id)
      client.name = name
      client.save!
      client
    end
  end
end

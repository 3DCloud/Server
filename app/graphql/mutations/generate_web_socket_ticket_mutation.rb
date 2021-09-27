# frozen_string_literal: true

module Mutations
  class GenerateWebSocketTicketMutation < BaseMutation
    type Types::WebSocketTicketType

    def resolve
      ticket = WebSocketTicket.new(
        ticket: SecureRandom.hex(64),
        user_id: context[:current_user].id,
        expires_at: DateTime.now.utc + 1.minute,
      )

      ticket.save!
      ticket
    end
  end
end

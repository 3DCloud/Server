# frozen_string_literal: true

module Types
  class WebSocketTicketType < Types::BaseObject
    field :user, Types::UserType, null: false
    field :ticket, String, null: false
  end
end

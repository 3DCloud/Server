# frozen_string_literal: true

module Types
  class ClientType < Types::BaseObject
    field :id, String, null: false
    field :name, String, null: true
    field :authorized, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

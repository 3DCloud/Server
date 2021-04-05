# frozen_string_literal: true

module Types
  class DeviceType < Types::BaseObject
    field :id, ID, null: false
    field :device_name, String, null: false
    field :device_id, String, null: false
    field :is_portable_device_id, Boolean, null: false
    field :last_seen, GraphQL::Types::ISO8601DateTime, null: false
    field :client_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

# frozen_string_literal: true

module Types
  class GCodeSettingsType < Types::BaseObject
    field :id, ID, null: false
    field :start_g_code, String, null: true
    field :end_g_code, String, null: true
    field :cancel_g_code, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

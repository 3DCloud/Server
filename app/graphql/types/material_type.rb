# frozen_string_literal: true

module Types
  class MaterialType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :brand, String, null: false
    field :net_filament_weight, Float, null: false
    field :empty_spool_weight, Float, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :material_colors, [MaterialColorType], null: false
  end
end

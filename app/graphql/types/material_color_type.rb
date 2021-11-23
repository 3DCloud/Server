# frozen_string_literal: true

module Types
  class MaterialColorType < Types::BaseObject
    field :id, ID, null: false
    field :material, MaterialType, null: false
    field :name, String, null: false
    field :color, String, null: false
  end
end

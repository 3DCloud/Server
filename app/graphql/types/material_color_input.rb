# frozen_string_literal: true

module Types
  class MaterialColorInput < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: true
    argument :color, String, required: true
  end
end

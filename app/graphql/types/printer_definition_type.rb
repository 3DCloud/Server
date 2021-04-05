# frozen_string_literal: true

module Types
  class PrinterDefinitionType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :start_gcode, String, null: true
    field :end_gcode, String, null: true
    field :pause_gcode, String, null: true
    field :resume_gcode, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :driver, String, null: false
  end
end

# frozen_string_literal: true

module Types
  class RuleType < Types::BaseObject
    field :action, [String], null: false
    field :subject, [String], null: false
    field :conditions, GraphQL::Types::JSON, null: true
    field :inverted, Boolean, null: true
  end
end

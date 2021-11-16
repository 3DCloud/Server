# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def authorize!(action, subject, *args)
      context[:current_ability].authorize!(action, subject, *args)
    end

    def self.authorized?(object, context)
      super && (!object.is_a?(ApplicationRecord) || context[:current_ability].authorize!(:read, object))
    end
  end
end

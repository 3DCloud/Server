# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    def authorize!(action, subject, *args)
      raise CanCan::AccessDenied if context[:current_ability].nil?

      context[:current_ability].authorize!(action, subject, *args)
    end
  end
end

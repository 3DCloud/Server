# frozen_string_literal: true

class ServerSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end

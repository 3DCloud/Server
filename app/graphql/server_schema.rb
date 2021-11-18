# frozen_string_literal: true

class ServerSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  rescue_from ActiveRecord::ActiveRecordError do |err|
    raise GraphQL::ExecutionError, err.message
  end

  rescue_from ApplicationCable::ApplicationCableError do |err|
    raise GraphQL::ExecutionError, err.message
  end

  rescue_from CanCan::AccessDenied do |err|
    raise GraphQL::ExecutionError, "You are not allowed to #{err.action} this resource."
  end
end

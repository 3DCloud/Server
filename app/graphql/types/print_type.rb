# frozen_string_literal: true

module Types
  class PrintType < Types::BaseObject
    field :id, ID, null: false
    field :uploaded_file, Types::UploadedFileType, null: false, scope: false
    field :printer, Types::PrinterType, null: false
    field :status, String, null: false
    field :user_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :started_at, GraphQL::Types::ISO8601DateTime, null: true
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end

# frozen_string_literal: true

module Types
  class UploadedFileType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :filename, String, null: false
    field :content_type, String, null: false
    field :byte_size, Int, null: false
    field :checksum, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :estimated_duration, Int, null: true

    def self.scope_items(items, context)
      items.where(deleted: false)
    end
  end
end

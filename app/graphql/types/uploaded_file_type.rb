# frozen_string_literal: true

module Types
  class UploadedFileType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :filename, String, null: false
    field :content_type, String, null: true
    field :byte_size, Int, null: true
    field :checksum, String, null: true
    field :url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :estimated_duration, Int, null: true

    def self.scope_items(items, context)
      items.where(deleted: false)
    end
  end
end

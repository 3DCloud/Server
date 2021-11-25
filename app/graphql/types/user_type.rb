# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :username, String, null: false
    field :name, String, null: false
    field :email_address, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :avatar, Types::ActiveStorageAttachmentType, null: true

    def avatar
      object.avatar.attachment
    end
  end
end

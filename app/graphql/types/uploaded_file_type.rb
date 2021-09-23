# frozen_string_literal: true

module Types
  class UploadedFileType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
  end
end

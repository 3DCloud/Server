# frozen_string_literal: true

module Types
  class ActiveStorageAttachmentType < Types::BaseObject
    field :content_type, String, null: false
    field :byte_size, Int, null: false
    field :checksum, String, null: false
    field :url, String, null: false
  end
end

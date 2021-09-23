# frozen_string_literal: true

module Mutations
  class CreateUploadFileRequest < BaseMutation
    argument :filename, String, required: true
    argument :byte_size, Int, required: true
    argument :checksum, String, required: true
    argument :content_type, String, required: true

    field :url, String, null: false
    field :headers, GraphQL::Types::JSON, null: false
    field :signed_id, String, null: false

    def resolve(filename:, byte_size:, checksum:, content_type:)
      blob = ActiveStorage::Blob.create_before_direct_upload!(
        filename: filename,
        byte_size: byte_size,
        checksum: checksum,
        content_type: content_type
      )

      {
        url: blob.service_url_for_direct_upload,
        headers: blob.service_headers_for_direct_upload,
        signed_id: blob.signed_id
      }
    end
  end
end

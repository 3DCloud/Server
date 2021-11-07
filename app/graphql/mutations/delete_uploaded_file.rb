# frozen_string_literal: true

module Mutations
  class DeleteUploadedFile < BaseMutation
    type Types::UploadedFileType

    argument :id, ID, required: true

    def resolve(id:)
      uploaded_file = UploadedFile.find(id)
      uploaded_file.file.purge_later
      uploaded_file.deleted = true
      uploaded_file.save!
      uploaded_file
    end
  end
end

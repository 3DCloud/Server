module Mutations
  class RecordFileUploaded < BaseMutation
    argument :signed_id, String, required: true

    type Types::UploadedFileType

    def resolve(signed_id:)
      file = UploadedFile.new(user_id: context[:current_user].id, file: signed_id)
      file.save!
      file
    end
  end
end

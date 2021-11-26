module Mutations
  class DeleteCancellationReason < BaseMutation
    type Types::CancellationReasonType

    argument :id, ID, required: true

    def resolve(id:)
      cancellation_reason_record = CancellationReason.find(id)
      authorize!(:delete, cancellation_reason_record)
      cancellation_reason_record.destroy!
    end
  end
end

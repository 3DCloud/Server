module Mutations
  class UpdateCancellationReason < BaseMutation
    type Types::CancellationReasonType

    argument :id, ID, required: true
    argument :cancellation_reason, Types::CancellationReasonInput, required: true

    def resolve(id:, cancellation_reason:)
      cancellation_reason_record = CancellationReason.find(id)
      authorize!(:update, cancellation_reason_record)

      cancellation_reason_record.update!(
        name: cancellation_reason.name,
        description: cancellation_reason.description
      )

      cancellation_reason_record
    end
  end
end

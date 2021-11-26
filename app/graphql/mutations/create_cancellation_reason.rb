module Mutations
  class CreateCancellationReason < BaseMutation
    type Types::CancellationReasonType

    argument :cancellation_reason, Types::CancellationReasonInput, required: true

    def resolve(cancellation_reason:)
      authorize!(:create, CancellationReason)

      cancellation_reason_record = CancellationReason.new(
        name: cancellation_reason.name,
        description: cancellation_reason.description
      )

      cancellation_reason_record.save!

      cancellation_reason_record
    end
  end
end

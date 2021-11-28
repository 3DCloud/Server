# frozen_string_literal: true

FactoryBot.define do
  factory :print do
    uploaded_file
    printer

    trait :canceled do
      status { 'canceled' }
      canceled_by { build(:user) }
      cancellation_reason
      cancellation_reason_details { 'Details about what happened' }
    end
  end
end

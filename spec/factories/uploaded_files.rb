# frozen_string_literal: true

FactoryBot.define do
  factory :uploaded_file do
    user { build(:user) }
  end
end

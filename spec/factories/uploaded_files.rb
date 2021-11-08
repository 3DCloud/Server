# frozen_string_literal: true

FactoryBot.define do
  factory :uploaded_file do
    user { build(:user) }
    filename { Faker::File.file_name(ext: 'gcode') }
  end
end

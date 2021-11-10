# frozen_string_literal: true

FactoryBot.define do
  factory :material_color do
    association :material
    name { 'Red' }
    color { 'FFCC00' }
  end
end

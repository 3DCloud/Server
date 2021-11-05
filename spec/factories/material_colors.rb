# frozen_string_literal: true

FactoryBot.define do
  factory :material_color do
    material { build(:material) }
    name { 'Red' }
    color { 'FFCC00' }
  end
end

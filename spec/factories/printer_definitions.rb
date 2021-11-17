# frozen_string_literal: true

FactoryBot.define do
  factory :printer_definition do
    sequence(:name) { |n| "PrinterDefinition#{n}" }
    driver { Faker::Creature::Animal.name.downcase }
  end
end

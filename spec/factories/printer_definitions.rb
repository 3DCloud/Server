# frozen_string_literal: true

FactoryBot.define do
  factory :printer_definition do
    name { Faker::Vehicle.make_and_model }
    driver { Faker::Creature::Animal.name.downcase }
  end
end

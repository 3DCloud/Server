# frozen_string_literal: true

FactoryBot.define do
  factory :printer do
    association :device
    association :printer_definition
    name { Faker::Games::ElderScrolls.unique.creature }

    after :build do |printer|
      printer.state = 'ready'
    end

    after :create do |printer|
      printer.state = 'ready'
    end
  end
end

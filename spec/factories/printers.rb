FactoryBot.define do
  factory :printer do
    device
    printer_definition
    name { Faker::Games::ElderScrolls.creature }
  end
end

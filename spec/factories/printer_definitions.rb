FactoryBot.define do
  factory :printer_definition do
    name { Faker::Vehicle.make_and_model }
    start_gcode { '' }
    end_gcode { '' }
    pause_gcode { '' }
    resume_gcode { '' }
    driver { Faker::Creature::Animal.name.downcase }
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UltiGCodeSettings, type: :model do
  let(:valid_data) do
    {
      printer_definition: build(:printer_definition),
      material: build(:material),
      hotend_temperature: 210,
      build_plate_temperature: 60,
      retraction_length: 6.5,
      end_of_print_retraction_length: 20,
      retraction_speed: 25,
      fan_speed: 100,
      flow_rate: 100,
    }
  end

  it 'is valid with all required attributes' do
    expect(UltiGCodeSettings.new(valid_data)).to be_valid
  end

  %i(
    printer_definition
    material
    hotend_temperature
    build_plate_temperature
    retraction_length
    end_of_print_retraction_length
    retraction_speed
    fan_speed
    flow_rate
  ).each do |attribute|
    it "is invalid when #{attribute} is missing" do
      expect(UltiGCodeSettings.new(valid_data.except(attribute))).to be_invalid
    end
  end

  it 'is invalid if fan_speed < 0' do
    expect(UltiGCodeSettings.new(valid_data.merge(fan_speed: -1))).to be_invalid
  end

  it 'is invalid if flow_rate < 0' do
    expect(UltiGCodeSettings.new(valid_data.merge(flow_rate: -1))).to be_invalid
  end

  it 'is invalid if fan_speed > 100' do
    expect(UltiGCodeSettings.new(valid_data.merge(fan_speed: 101))).to be_invalid
  end

  it 'is invalid if flow_rate > 100' do
    expect(UltiGCodeSettings.new(valid_data.merge(flow_rate: 101))).to be_invalid
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UltiGCodeSettings, type: :model do
  let(:valid_data) do
    {
      printer_definition: build(:printer_definition),
      material: build(:material),
      hotend_temperature_0_25: 210,
      retraction_length_0_25: 6.5,
      retraction_speed_0_25: 25,
      hotend_temperature_0_40: 210,
      retraction_length_0_40: 6.5,
      retraction_speed_0_40: 25,
      hotend_temperature_0_60: 210,
      retraction_length_0_60: 6.5,
      retraction_speed_0_60: 25,
      hotend_temperature_0_80: 210,
      retraction_length_0_80: 6.5,
      retraction_speed_0_80: 25,
      hotend_temperature_1_00: 210,
      retraction_length_1_00: 6.5,
      retraction_speed_1_00: 25,
      build_plate_temperature: 60,
      end_of_print_retraction_length: 20,
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
    hotend_temperature_0_25
    retraction_length_0_25
    retraction_speed_0_25
    hotend_temperature_0_40
    retraction_length_0_40
    retraction_speed_0_40
    hotend_temperature_0_60
    retraction_length_0_60
    retraction_speed_0_60
    hotend_temperature_0_80
    retraction_length_0_80
    retraction_speed_0_80
    hotend_temperature_1_00
    retraction_length_1_00
    retraction_speed_1_00
    build_plate_temperature
    end_of_print_retraction_length
    fan_speed
    flow_rate
  ).each do |attribute|
    it "is invalid when #{attribute} is missing" do
      expect(UltiGCodeSettings.new(valid_data.except!(attribute))).to be_invalid
    end
  end

  it 'is invalid if fan_speed < 0' do
    expect(UltiGCodeSettings.new(valid_data.merge(fan_speed: -1))).to be_invalid
  end

  it 'is invalid if flow_rate < 0' do
    expect(UltiGCodeSettings.new(valid_data.merge(flow_rate: -1))).to be_invalid
  end

  it 'is invalid if fan_speed > 150' do
    expect(UltiGCodeSettings.new(valid_data.merge(fan_speed: 151))).to be_invalid
  end

  it 'is invalid if flow_rate > 150' do
    expect(UltiGCodeSettings.new(valid_data.merge(flow_rate: 151))).to be_invalid
  end
end

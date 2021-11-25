# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrinterExtruder, type: :model do
  let(:valid_data) do
    {
      printer: build(:printer),
      material_color: build(:material_color, material: build(:material)),
      extruder_index: 0,
      ulti_g_code_nozzle_size: 'size_0_40',
    }
  end

  it 'is valid with all required attributes' do
    expect(PrinterExtruder.new(valid_data)).to be_valid
  end

  %i(printer material_color extruder_index).each do |attribute|
    it "is invalid when #{attribute} is missing" do
      expect(PrinterExtruder.new(valid_data.except!(attribute))).to be_invalid
    end
  end

  %i(size_0_25 size_0_40 size_0_60 size_0_80 size_1_00).each do |size|
    it "is valid if ulti_g_code_nozzle_size is #{size}" do
      expect(PrinterExtruder.new(valid_data.merge(ulti_g_code_nozzle_size: size))).to be_valid
    end
  end

  it 'is invalid if ulti_g_code_nozzle_size is not valid' do
    expect(PrinterExtruder.new(valid_data.merge(ulti_g_code_nozzle_size: 'size_0_10'))).to be_invalid
  end

  it 'is invalid if extruder_index < 0' do
    expect(PrinterExtruder.new(valid_data.merge(extruder_index: -1))).to be_invalid
  end

  it 'is valid if extruder_index overlaps on different printers' do
    create(:printer_extruder, extruder_index: 0)
    expect(build(:printer_extruder, extruder_index: 0)).to be_valid
  end

  it 'is invalid if extruder_index overlaps on the same printer' do
    printer = create(:printer)
    create(:printer_extruder, printer: printer, extruder_index: 0)
    expect(build(:printer_extruder, printer: printer, extruder_index: 0)).to be_invalid
  end
end

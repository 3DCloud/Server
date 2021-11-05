# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrinterMaterial, type: :model do
  let(:valid_data) do
    {
      printer: build(:printer),
      material: build(:material),
      extruder_index: 0,
    }
  end

  it 'is valid with all required attributes' do
    expect(PrinterMaterial.new(valid_data)).to be_valid
  end

  %i(printer material extruder_index).each do |attribute|
    it "is invalid when #{attribute} is missing attributes" do
      expect(PrinterMaterial.new(valid_data)).to be_valid
    end
  end

  it 'is invalid if extruder_index < 0' do
    expect(PrinterMaterial.new(valid_data.merge(extruder_index: -1))).to be_invalid
  end

  it 'is valid if extruder_index overlaps on different printers' do
    create(:printer_material, extruder_index: 0)
    expect(build(:printer_material, extruder_index: 0)).to be_valid
  end

  it 'is invalid if extruder_index overlaps on the same printer' do
    printer = create(:printer)
    create(:printer_material, printer: printer, extruder_index: 0)
    expect(build(:printer_material, printer: printer, extruder_index: 0)).to be_invalid
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GCodeSettings, type: :model do
  let(:valid_data) do
    {
      printer_definition: build(:printer_definition)
    }
  end

  it 'is valid with all required attributes' do
    expect(GCodeSettings.new(valid_data)).to be_valid
  end

  %i(
    printer_definition
  ).each do |attribute|
    it "is invalid when #{attribute} is missing" do
      expect(GCodeSettings.new(valid_data.except(attribute))).to be_invalid
    end
  end
end

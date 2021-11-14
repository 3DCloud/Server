# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MaterialColor, type: :model do
  let(:valid_data) do
    {
      material: build(:material),
      name: 'Red',
      color: '#FFCC00',
    }
  end

  it 'is valid with all required attributes' do
    expect(MaterialColor.new(valid_data)).to be_valid
  end

  %i(name color).each do |attribute|
    it "is invalid if #{attribute} is missing" do
      expect(MaterialColor.new(valid_data.except(attribute))).to be_invalid
    end
  end

  it 'is invalid when color length != 6' do
    expect(MaterialColor.new(valid_data.merge(color: 'abcde'))).to be_invalid
  end

  it 'is invalid when color is not a valid hex string' do
    expect(MaterialColor.new(valid_data.merge(color: '88888j'))).to be_invalid
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Material, type: :model do
  let(:valid_data) do
    {
      name: 'PLA',
      brand: 'Generic',
      filament_diameter: 1.75,
      net_filament_weight: 1000,
      empty_spool_weight: 285,
    }
  end

  it 'is valid with all required attributes' do
    expect(Material.new(valid_data)).to be_valid
  end

  %i(name brand filament_diameter net_filament_weight empty_spool_weight).each do |attribute|
    it "is invalid if #{attribute} is missing" do
      expect(Material.new(valid_data.except(attribute))).to be_invalid
    end
  end

  it 'is invalid if filament_diameter < 0' do
    expect(Material.new(valid_data.merge(filament_diameter: -1))).to be_invalid
  end

  it 'is invalid if net_filament_weight < 0' do
    expect(Material.new(valid_data.merge(net_filament_weight: -1))).to be_invalid
  end

  it 'is invalid if empty_spool_weight < 0' do
    expect(Material.new(valid_data.merge(empty_spool_weight: -1))).to be_invalid
  end

  it 'is invalid if filament_diameter >= 10' do
    expect(Material.new(valid_data.merge(filament_diameter: 10))).to be_invalid
  end

  it 'is invalid if net_filament_weight >= 100,000' do
    expect(Material.new(valid_data.merge(net_filament_weight: 100_000))).to be_invalid
  end

  it 'is invalid if empty_spool_weight >= 1000' do
    expect(Material.new(valid_data.merge(empty_spool_weight: 1000))).to be_invalid
  end
end

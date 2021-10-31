# frozen_string_literal: true

require 'rails_helper'
require 'material_usage_calculator'

RSpec.describe MaterialUsageCalculator do
  let(:calculator) { MaterialUsageCalculator.new }

  describe 'add' do
    it 'calculates a single move' do
      calculator.add(5)

      expect(calculator.lengths).to eq([5])
    end

    it 'calculates multiple moves' do
      calculator.add(5)
      calculator.add(2)
      calculator.add(3)

      expect(calculator.lengths).to eq([10])
    end

    it 'always returns a rounded integer' do
      calculator.add(0.5)

      expect(calculator.lengths).to eq([1])
    end

    it 'calculates multiple moves with retractions' do
      calculator.add(-1)
      calculator.add(5)
      calculator.add(-10)
      calculator.add(3)

      expect(calculator.lengths).to eq([4])
    end

    it 'calculates multiple moves with retractions and multiple tools' do
      calculator.add(-1)
      calculator.add(5)
      calculator.add(-3)

      calculator.current_tool = 1
      calculator.add(-10)
      calculator.add(3)

      calculator.current_tool = 0
      calculator.add(4)
      calculator.add(-1)

      expect(calculator.lengths).to eq([5, 0])
    end
  end

  describe 'set_length' do
    it 'sets the length for a single tool' do
      calculator.set_length(8, 0)

      expect(calculator.lengths).to eq([8])
    end

    it 'sets the length for the specified tools' do
      calculator.set_length(13, 1)
      calculator.set_length(8, 3)

      expect(calculator.lengths).to eq([0, 13, 0, 8])
    end
  end
end

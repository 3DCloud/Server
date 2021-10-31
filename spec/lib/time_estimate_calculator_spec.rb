# frozen_string_literal: true

require 'rails_helper'
require 'time_estimate_calculator'

RSpec.describe TimeEstimateCalculator do
  let(:um3) {
    TimeEstimateCalculator.new(
      max_feedrate: [300, 300, 40, 45],
      max_acceleration: [9000, 9000, 100, 10_000],
      max_xy_jerk: 20,
      max_z_jerk: 0.4,
      max_e_jerk: 5,
      minimum_feedrate: 0,
      acceleration: 3000)
  }

  let(:always_50) {
    TimeEstimateCalculator.new(
      max_feedrate: [50, 50, 50, 50],
      max_acceleration: [50, 50, 50, 50],
      max_xy_jerk: 1000,
      max_z_jerk: 1000,
      max_e_jerk: 1000,
      minimum_feedrate: 0,
      acceleration: 50)
  }

  let(:jerkless) {
    TimeEstimateCalculator.new(
      max_feedrate: [50, 50, 50, 50],
      max_acceleration: [50, 50, 50, 50],
      max_xy_jerk: 0,
      max_z_jerk: 0,
      max_e_jerk: 0,
      minimum_feedrate: 0,
      acceleration: 50)
  }

  it 'single line only jerk' do
    calculator = always_50

    calculator.plan([1000, 0, 0, 0], 50)

    t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    decelerate_distance = 0.5 * 50.0 * t * t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * t
    cruise_distance = 1000.0 - decelerate_distance

    expect(calculator.calculate).to eq(cruise_distance / 50 + t)
  end

  it 'double line only jerk' do
    calculator = always_50

    calculator.plan([1000, 0, 0, 0], 50)
    calculator.plan([1000, 0, 0, 0], 50)

    t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    decelerate_distance = 0.5 * 50.0 * t * t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * t
    cruise_distance = 2000.0 - decelerate_distance

    expect(calculator.calculate).to eq(cruise_distance / 50 + t)
  end

  it 'single line no jerk' do
    calculator = jerkless

    calculator.plan([1000, 0, 0, 0], 50)

    accelerate_distance = 0.5 * 50 * 1 * 1 + 0 * 1
    decelerate_t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    decelerate_distance = 0.5 * 50.0 * decelerate_t * decelerate_t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * decelerate_t
    cruise_distance = 1000.0 - accelerate_distance - decelerate_distance

    expect(calculator.calculate).to eq(1 + cruise_distance / 50 + decelerate_t)
  end

  it 'double line no jerk' do
    calculator = jerkless

    calculator.plan([1000, 0, 0, 0], 50)
    calculator.plan([1000, 0, 0, 0], 50)

    accelerate_distance = 0.5 * 50 * 1 * 1 + 0 * 1
    decelerate_t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    decelerate_distance = 0.5 * 50.0 * decelerate_t * decelerate_t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * decelerate_t
    cruise_distance = 2000.0 - accelerate_distance - decelerate_distance

    expect(calculator.calculate).to eq(1 + cruise_distance / 50 + decelerate_t)
  end

  it 'short line' do
    calculator = jerkless

    calculator.plan([25, 0, 0, 0], 50)

    d_apex = 25.0 / 2.0 + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * TimeEstimateCalculator::MINIMUM_PLANNER_SPEED / (4.0 * 50.0)
    t_apex = Math.sqrt(2.0 * 50.0 * d_apex) / 50.0
    # Accelerate until t_apex. How fast will we be going?
    max_speed = 50.0 * t_apex
    # Then how long do we decelerate?
    decelerate_t = (max_speed - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0

    expect(calculator.calculate).to eq(t_apex + decelerate_t)
  end

  it 'diagonal line no jerk' do
    calculator = jerkless

    calculator.plan([1000, 1000, 0, 0], 50)

    accelerate_distance = 0.5 * 50.0 * 1.0 * 1.0 + 0.0 * 1.0
    decelerate_t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    decelerate_distance = 0.5 * 50.0 * decelerate_t * decelerate_t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * decelerate_t
    cruise_distance = Math.sqrt(2.0) * 1000.0 - accelerate_distance - decelerate_distance

    expect(calculator.calculate).to eq(1 + cruise_distance / 50 + decelerate_t)
  end

  it 'straight angle only jerk' do
    calculator = always_50

    calculator.plan([1000, 0, 0, 0], 50)
    calculator.plan([0, 1000, 0, 0], 50)

    first_cruise_time = 1000.0 / 50.0
    t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    decelerate_distance = 0.5 * 50.0 * t * t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * t
    cruise_distance = 1000.0 - decelerate_distance
    second_cruise_time = cruise_distance / 50.0

    expect(calculator.calculate).to eq(first_cruise_time + second_cruise_time + t)
  end

  it 'straight angle no jerk' do
    calculator = jerkless

    calculator.plan([1000, 0, 0, 0], 50)
    calculator.plan([0, 1000, 0, 0], 50)

    first_accelerate_distance = 0.5 * 50.0 * 1.0 * 1.0 + 0.0 * 1.0
    first_decelerate_distance = first_accelerate_distance
    first_cruise_distance = 1000.0 - first_accelerate_distance - first_decelerate_distance
    second_accelerate_distance = first_accelerate_distance
    second_decelerate_t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / 50.0
    second_decelerate_distance = 0.5 * 50.0 * second_decelerate_t * second_decelerate_t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * second_decelerate_t
    second_cruise_distance = 1000.0 - second_accelerate_distance - second_decelerate_distance

    expect(calculator.calculate).to eq(1 + first_cruise_distance / 50 + 1 + 1 + second_cruise_distance / 50 + second_decelerate_t)
  end

  it 'straight angle partial jerk' do
    calculator = TimeEstimateCalculator.new

    calculator.plan([1000, 0, 0, 0], 50)
    calculator.plan([0, 1000, 0, 0], 50)

    jerk = 20
    acceleration = 3000
    junction_speed = Math.sqrt(jerk * jerk / 4 + jerk * jerk / 4)

    first_accelerate_t = (50.0 - jerk / 2) / acceleration
    first_accelerate_distance = 0.5 * acceleration * first_accelerate_t * first_accelerate_t + jerk / 2 * first_accelerate_t
    first_decelerate_t = (50.0 - junction_speed) / acceleration
    first_decelerate_distance = 0.5 * acceleration * first_decelerate_t * first_decelerate_t + junction_speed * first_decelerate_t
    first_cruise_distance = 1000.0 - first_accelerate_distance - first_decelerate_distance

    second_accelerate_t = (50.0 - junction_speed) / acceleration
    second_accelerate_distance = 0.5 * acceleration * second_accelerate_t * second_accelerate_t + junction_speed * second_accelerate_t
    second_decelerate_t = (50.0 - TimeEstimateCalculator::MINIMUM_PLANNER_SPEED) / acceleration
    second_decelerate_distance = 0.5 * acceleration * second_decelerate_t * second_decelerate_t + TimeEstimateCalculator::MINIMUM_PLANNER_SPEED * second_decelerate_t
    second_cruise_distance = 1000.0 - second_accelerate_distance - second_decelerate_distance

    expect(calculator.calculate).to eq(first_accelerate_t + first_cruise_distance / 50.0 + first_decelerate_t + second_accelerate_t + second_cruise_distance / 50.0 + second_decelerate_t)
  end
end

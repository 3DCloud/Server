# frozen_string_literal: true

# Adapted from CuraEngine https://github.com/Ultimaker/CuraEngine/blob/master/src/timeEstimate.cpp
class TimeEstimateCalculator
  NUM_AXES = 4
  MINIMUM_PLANNER_SPEED = 0.05 # mm/s

  class Block
    attr_accessor :accelerate_until
    attr_accessor :decelerate_after
    attr_accessor :initial_feedrate
    attr_accessor :final_feedrate
    attr_accessor :entry_speed
    attr_accessor :max_entry_speed
    attr_accessor :nominal_length_flag
    attr_accessor :nominal_feedrate
    attr_accessor :max_travel
    attr_accessor :distance
    attr_accessor :acceleration
    attr_accessor :delta
    attr_accessor :abs_delta
    attr_accessor :recalculate_flag
  end

  def initialize(
    max_feedrate: [600, 600, 40, 25], # mm/s
    minimum_feedrate: 0.01,
    acceleration: 3000,
    max_acceleration: [9000, 9000, 100, 10_000], # mm/s²
    max_xy_jerk: 20,
    max_z_jerk: 0.4,
    max_e_jerk: 5)
    @max_feedrate = max_feedrate
    @minimum_feedrate = minimum_feedrate
    @acceleration = acceleration
    @max_acceleration = max_acceleration
    @max_xy_jerk = max_xy_jerk
    @max_z_jerk = max_z_jerk
    @max_e_jerk = max_e_jerk
    @previous_feedrate = [0, 0, 0, 0]
    @previous_nominal_feedrate = 0
    @blocks = []
  end

  def plan(pos_delta, feedrate)
    block = Block.new

    block.delta = [0, 0, 0, 0]
    block.abs_delta = [0, 0, 0, 0]

    (0...NUM_AXES).each do |i|
      block.delta[i] = pos_delta[i]
      block.abs_delta[i] = block.delta[i].abs
    end

    block.max_travel = block.abs_delta.max

    if block.max_travel <= 0
      return
    end

    if feedrate < @minimum_feedrate
      feedrate = @minimum_feedrate
    end

    block.distance = Math.sqrt(block.abs_delta[0]**2 + block.abs_delta[1]**2 + block.abs_delta[2]**2)

    if block.distance == 0
      block.distance = block.abs_delta[3]
    end

    block.nominal_feedrate = feedrate

    current_feedrate = [0, 0, 0, 0]
    current_abs_feedrate = [0, 0, 0, 0]
    feedrate_factor = 1

    (0...NUM_AXES).each do |i|
      current_feedrate[i] = (block.delta[i] * feedrate) / block.distance
      current_abs_feedrate[i] = current_feedrate[i].abs

      if current_abs_feedrate[i] > @max_feedrate[i]
        feedrate_factor = [feedrate_factor, @max_feedrate[i] / current_abs_feedrate[i]].min
      end
    end

    if feedrate_factor < 1
      (0...NUM_AXES).each do |i|
        current_feedrate[i] *= feedrate_factor
        current_abs_feedrate[i] *= feedrate_factor
      end

      block.nominal_feedrate *= feedrate_factor
    end

    block.acceleration = @acceleration

    (0...NUM_AXES).each do |i|
      if block.acceleration * (block.abs_delta[i] / block.distance) > @max_acceleration[i]
        block.acceleration = @max_acceleration[i]
      end
    end

    vmax_junction = @max_xy_jerk / 2.0
    vmax_junction_factor = 1

    if current_abs_feedrate[2] > @max_z_jerk / 2.0
      vmax_junction = [vmax_junction, @max_z_jerk / 2.0].min
    end

    if current_abs_feedrate[3] > @max_e_jerk / 2.0
      vmax_junction = [vmax_junction, @max_e_jerk / 2.0].min
    end

    vmax_junction = [vmax_junction, block.nominal_feedrate].min
    safe_speed = vmax_junction

    if @blocks.length > 0 && @previous_nominal_feedrate > 0.0001
      xy_jerk = Math.sqrt(
        (current_feedrate[0] - @previous_feedrate[0])**2 + (current_feedrate[1] - @previous_feedrate[1])**2
      )

      vmax_junction = block.nominal_feedrate

      if xy_jerk > @max_xy_jerk
        vmax_junction_factor = @max_xy_jerk / xy_jerk
      end

      if (current_feedrate[2] - @previous_feedrate[2]).abs > @max_z_jerk
        vmax_junction_factor = [
          vmax_junction_factor,
          @max_z_jerk / (current_feedrate[2] - @previous_feedrate[2]).abs
        ].min
      end

      if (current_feedrate[3] - @previous_feedrate[3]).abs > @max_e_jerk
        vmax_junction_factor = [
          vmax_junction_factor,
          @max_e_jerk / (current_feedrate[3] - @previous_feedrate[3]).abs
        ].min
      end

      vmax_junction = [
        @previous_nominal_feedrate,
        vmax_junction * vmax_junction_factor
      ].min
    end

    block.max_entry_speed = vmax_junction

    v_allowable = max_allowable_speed(-block.acceleration, MINIMUM_PLANNER_SPEED, block.distance)
    block.entry_speed = [vmax_junction, v_allowable].min
    block.nominal_length_flag = block.nominal_feedrate <= v_allowable
    block.recalculate_flag = true

    @previous_feedrate = current_feedrate
    @previous_nominal_feedrate = block.nominal_feedrate

    calculate_trapezoid_for_block(block, block.entry_speed / block.nominal_feedrate, safe_speed / block.nominal_feedrate)

    @blocks << block
  end

  def calculate
    reverse_pass
    forward_pass
    recalculate_trapezoids

    total = 0

    @blocks.each do |block|
      plateau_distance = block.decelerate_after - block.accelerate_until

      total += acceleration_time_from_distance(block.initial_feedrate, block.accelerate_until, block.acceleration)
      total += plateau_distance / block.nominal_feedrate
      total += acceleration_time_from_distance(block.final_feedrate, (block.distance - block.decelerate_after), block.acceleration)
    end

    total
  end

  private
    def reverse_pass
      blocks = [nil, nil]

      (@blocks.length - 1).downto(0).each do |i|
        blocks[1] = blocks[0]
        blocks[0] = blocks[i]
        planner_reverse_pass_kernel(blocks[0], blocks[1])
      end
    end

    def planner_reverse_pass_kernel(current_block, next_block)
      return unless current_block && next_block

      if current_block.entry_speed != current_block.max_entry_speed
        if !current_block.nominal_length_flag && current_block.max_entry_speed > next_block.entry_speed
          current_block.entry_speed = [
            current_block.max_entry_speed,
            max_allowable_speed(-current_block.acceleration, next_block.entry_speed, current_block.distance)
          ].min
        else
          current_block.entry_speed = current_block.max_entry_speed
        end

        current_block.recalculate_flag = true
      end
    end

    def forward_pass
      blocks = [nil, nil]

      0.upto(@blocks.length - 1).each do |i|
        blocks[0] = blocks[1]
        blocks[1] = @blocks[i]
        planner_forward_pass_kernel(blocks[0], blocks[1])
      end
    end

    def planner_forward_pass_kernel(previous_block, current_block)
      return unless previous_block

      unless previous_block.nominal_length_flag
        if previous_block.entry_speed < current_block.max_entry_speed
          entry_speed = [current_block.entry_speed, max_allowable_speed(-previous_block.acceleration, previous_block.entry_speed, previous_block.distance)].min

          if current_block.entry_speed != entry_speed
            current_block.entry_speed = entry_speed
            current_block.recalculate_flag = true
          end
        end
      end
    end

    def recalculate_trapezoids
      next_block = nil

      (0...@blocks.length).each { |i|
        current_block = next_block
        next_block = @blocks[i]

        if current_block
          if current_block.recalculate_flag || next_block.recalculate_flag
            calculate_trapezoid_for_block(current_block, current_block.entry_speed / current_block.nominal_feedrate, next_block.entry_speed / current_block.nominal_feedrate)
            current_block.recalculate_flag = false
          end
        end
      }

      if next_block != nil
        calculate_trapezoid_for_block(next_block, next_block.entry_speed / next_block.nominal_feedrate, MINIMUM_PLANNER_SPEED / next_block.nominal_feedrate)
        next_block.recalculate_flag = false
      end
    end

    def acceleration_time_from_distance(initial_feedrate, distance, acceleration)
      discriminant = [0.0, initial_feedrate**2 - 2 * acceleration * -distance].max
      (-initial_feedrate + Math.sqrt(discriminant)) / acceleration
    end

    def max_allowable_speed(acceleration, target_velocity, distance)
      Math.sqrt(target_velocity * target_velocity - 2 * acceleration * distance)
    end

    def calculate_trapezoid_for_block(block, entry_factor, exit_factor)
      initial_feedrate = block.nominal_feedrate * entry_factor
      final_feedrate = block.nominal_feedrate * exit_factor

      accelerate_distance = estimate_acceleration_distance(initial_feedrate, block.nominal_feedrate, block.acceleration)
      decelerate_distance = estimate_acceleration_distance(block.nominal_feedrate, final_feedrate, -block.acceleration)

      plateau_distance = block.distance - accelerate_distance - decelerate_distance

      if plateau_distance < 0
        accelerate_distance = [0, intersection_distance(initial_feedrate, final_feedrate, block.acceleration, block.distance)].max
        accelerate_distance = [accelerate_distance, block.distance].min
        plateau_distance = 0
      end

      block.accelerate_until = accelerate_distance
      block.decelerate_after = accelerate_distance + plateau_distance
      block.initial_feedrate = initial_feedrate
      block.final_feedrate = final_feedrate
    end

    def estimate_acceleration_distance(initial_rate, target_rate, acceleration)
      return 0 if acceleration == 0

      (target_rate**2 - initial_rate**2) / (2 * acceleration)
    end

    def intersection_distance(initial_rate, final_rate, acceleration, distance)
      return 0 if acceleration == 0

      (2 * acceleration * distance - initial_rate**2 + final_rate**2) / (4 * acceleration)
    end
end

# frozen_string_literal: true

require 'time_estimate_calculator'

class GcodeFile
  attr_reader :estimated_duration
  attr_reader :flavor
  attr_reader :filament_used
  attr_reader :nozzle_diameters

  def initialize(estimated_duration, flavor, filament_used, nozzle_diameters)
    @estimated_duration = estimated_duration
    @flavor = flavor
    @filament_used = filament_used
    @nozzle_diameters = nozzle_diameters
  end

  def to_hash
    {
      estimated_duration: estimated_duration,
      flavor: flavor,
      filament_used: filament_used,
      nozzle_diameters: nozzle_diameters,
    }
  end

  def self.parse_from_file(file_path)
    is_e_relative = false
    is_position_relative = false
    is_header_parsed = false
    speed = 100 # default (initial) speed in mm/s
    last_position = [0, 0, 0, 0]
    flavor = 'Unknown'
    estimate_run_time = true
    estimate_material_length = true
    estimated_duration = 0
    nozzle_diameters = [] # UltiGCode + Griffin

    calculator = TimeEstimateCalculator.new
    material_calculator = MaterialUsageCalculator.new

    File.readlines(file_path).each do |line|
      line = line.strip
      next if line.blank?

      if !is_header_parsed && line.start_with?(';')
        if line.include?(':')
          (key, value) = line[1..].split(':')
          case key.strip
          when 'FLAVOR'
            flavor = value
          when 'TIME', 'PRINT.TIME' # Marlin/UltiGCode, Griffin
            estimate_run_time = false
            estimated_duration = value.to_i
          when 'MATERIAL' # UltiGCode
            estimate_material_length = false
            material_calculator.set_length(value.to_i, 0)
          when 'MATERIAL2' # UltiGCode
            estimate_material_length = false
            material_calculator.set_length(value.to_i, 1)
          when /EXTRUDER_TRAIN\.(\d+)\.MATERIAL\.VOLUME_USED/ # Griffin
            estimate_material_length = false
            material_calculator.set_length(value.to_i, "#{$1}".to_i)
          when 'NOZZLE_DIAMETER' # UltiGCode
            nozzle_diameters = [value.to_f]
          when /EXTRUDER_TRAIN\.(\d+)\.NOZZLE\.DIAMETER/
            index = "#{$1}".to_i
            nozzle_diameters += [0] * (index - nozzle_diameters.length + 1)
            nozzle_diameters[index] = value.to_f
          when 'Filament used' # Marlin
            estimate_material_length = false
            count = 0

            value.scan(/(\d+(?:\.\d+)?)m/) do |match|
              material_calculator.set_length((match[0].to_f * 1000).round.to_i, count)
              count += 1
            end
          end
        end
      else
        is_header_parsed = true
      end

      next if line.start_with?(';')

      if line.include?(';')
        line = line[0...line.index(';')].strip
      end

      code = line[0...line.index(' ')]

      case code
      when /T\d/ # Select Tool (https://marlinfw.org/docs/gcode/T001-T002.html)
        material_calculator.current_tool = line[1].to_i
      when 'G0', 'G1' # Linear Move (https://marlinfw.org/docs/gcode/G000-G001.html)
        pos = last_position.dup

        line.scan(/([EFXYZ])(-?\d+(?:\.\d+)?)/) do |match|
          case match[0]
          when 'X'
            pos[0] = match[1].to_f
          when 'Y'
            pos[1] = match[1].to_f
          when 'Z'
            pos[2] = match[1].to_f
          when 'E'
            pos[3] = match[1].to_f
          when 'F'
            speed = match[1].to_f / 60 # we want mm/s, G-code is in mm/min
          end
        end

        if is_position_relative
          pos_delta = [
            pos[0],
            pos[1],
            pos[2],
            is_e_relative ? pos[3] : pos[3] - last_position[3],
          ]
        else
          pos_delta = [
            pos[0] - last_position[0],
            pos[1] - last_position[1],
            pos[2] - last_position[2],
            is_e_relative ? pos[3] : pos[3] - last_position[3],
          ]
        end

        if estimate_run_time
          calculator.plan(pos_delta, speed)
        end

        if estimate_material_length
          material_calculator.add(pos_delta[3])
        end

        last_position = pos
      when 'G90' # Absolute Positioning (https://marlinfw.org/docs/gcode/G090.html)
        is_position_relative = false
        is_e_relative = false
      when 'G91' # Relative Positioning (https://marlinfw.org/docs/gcode/G091.html)
        is_position_relative = true
        is_e_relative = true
      when 'G92' # Set Position (https://marlinfw.org/docs/gcode/G092.html)
        line.scan(/([EFXYZ])(-?\d+(?:\.\d+)?)/) do |match|
          case match[0]
          when 'X'
            last_position[0] = match[1].to_f
          when 'Y'
            last_position[1] = match[1].to_f
          when 'Z'
            last_position[2] = match[1].to_f
          when 'E'
            last_position[3] = match[1].to_f
          end
        end
      when 'M82' # E Absolute (https://marlinfw.org/docs/gcode/M082.html)
        is_e_relative = false
      when 'M83' # E Relative (https://marlinfw.org/docs/gcode/M083.html)
        is_e_relative = true
      end
    end

    if estimate_run_time
      estimated_duration = calculator.calculate.to_i
    end

    GcodeFile.new(estimated_duration, flavor, material_calculator.lengths, nozzle_diameters)
  end
end

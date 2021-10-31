# frozen_string_literal: true

class MaterialUsageCalculator
  class Tool
    attr_accessor :length
    attr_accessor :current_position

    def initialize
      @length = 0
      @current_position = 0
    end
  end

  attr_reader :current_tool

  def initialize
    @tools = [Tool.new]
    @current_tool = 0
  end

  def current_tool=(value)
    ensure_tool_index value
    @current_tool = value
  end

  def extruder_count
    @tools.length
  end

  def lengths
    @tools.map(&:length).map(&:round).map(&:to_i)
  end

  def set_length(length, tool_index)
    ensure_tool_index tool_index
    @tools[tool_index].length = length
  end

  def add(position_delta)
    tool = @tools[current_tool]
    tool.current_position += position_delta
    tool.length = [tool.current_position, tool.length].max
  end

  private
    def ensure_tool_index(tool_index)
      if tool_index > @tools.length - 1
        @tools += Array.new(tool_index - @tools.length + 1) { Tool.new }
      end
    end
end

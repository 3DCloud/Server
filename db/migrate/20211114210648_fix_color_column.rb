# frozen_string_literal: true

class FixColorColumn < ActiveRecord::Migration[6.1]
  def up
    change_column :material_colors, :color, :string, limit: 7
  end
end

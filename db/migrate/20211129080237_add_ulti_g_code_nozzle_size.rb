# frozen_string_literal: true

class AddUltiGCodeNozzleSize < ActiveRecord::Migration[6.1]
  def change
    add_column :uploaded_files, :ulti_g_code_nozzle_size, :string
  end
end

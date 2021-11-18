# frozen_string_literal: true

class AddSerialNumberColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :devices, :device_name, :name
    rename_column :devices, :hardware_identifier, :path
    add_column :devices, :serial_number, :string
    remove_column :devices, :is_portable_hardware_identifier, :boolean
  end
end

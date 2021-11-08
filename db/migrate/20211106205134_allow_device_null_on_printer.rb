# frozen_string_literal: true

class AllowDeviceNullOnPrinter < ActiveRecord::Migration[6.1]
  def change
    change_column_null :printers, :device_id, true
  end
end

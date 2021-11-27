# frozen_string_literal: true

class RemovePrinterStateFromDatabase < ActiveRecord::Migration[6.1]
  def change
    remove_column :printers, :state, :string
  end
end

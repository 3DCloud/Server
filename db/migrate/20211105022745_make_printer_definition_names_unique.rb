class MakePrinterDefinitionNamesUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :printer_definitions, :name, unique: true
  end
end

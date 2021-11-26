# frozen_string_literal: true

class AddCancellationReasons < ActiveRecord::Migration[6.1]
  def change
    create_table :cancellation_reasons do |t|
      t.string :name, null: false
      t.string :description
      t.index :name, unique: true

      t.timestamps
    end

    add_reference :prints, :cancellation_reason, foreign_key: true
    add_column :prints, :cancellation_reason_details, :string
  end
end

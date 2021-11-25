# frozen_string_literal: true

class AddPrintCanceledBy < ActiveRecord::Migration[6.1]
  def change
    add_reference :prints, :canceled_by, foreign_key: { to_table: :users }
  end
end

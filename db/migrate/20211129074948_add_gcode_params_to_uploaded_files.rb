# frozen_string_literal: true

class AddGcodeParamsToUploadedFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :uploaded_files, :estimated_duration, :integer
  end
end

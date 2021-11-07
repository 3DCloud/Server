# frozen_string_literal: true

class AddUploadedFileDeletedColumn < ActiveRecord::Migration[6.1]
  def up
    add_column :uploaded_files, :deleted, :boolean, null: false, default: false
    add_column :uploaded_files, :filename, :string, null: true

    UploadedFile.in_batches.each_record do |uploaded_file|
      uploaded_file.filename = uploaded_file.file.filename || 'unknown'
      uploaded_file.deleted = uploaded_file.file.blank?
      uploaded_file.save!
    end

    change_column_null :uploaded_files, :filename, false
  end

  def down
    remove_column :uploaded_files, :filename
    remove_column :uploaded_files, :deleted
  end
end

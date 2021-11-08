class RemoveDeletedColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :uploaded_files, :deleted, :boolean
  end
end

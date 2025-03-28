class AddExternalApiUrlToBranches < ActiveRecord::Migration[8.0]
  def change
    remove_column :branches, :content_id
    remove_column :branches, :slug_note
    remove_column :branches, :user_note_username
  end
end

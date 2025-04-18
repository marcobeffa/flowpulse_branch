class ChangeContentToUpdateContentInBranches < ActiveRecord::Migration[8.0]
  def change
    remove_column :branches, :content, :boolean
    add_column :branches, :updated_content, :datetime
    add_column :branches, :content, :jsonb
    
  end
end

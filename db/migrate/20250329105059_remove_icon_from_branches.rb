class RemoveIconFromBranches < ActiveRecord::Migration[8.0]
  def change
    remove_column :branches, :icon, :string
  end
end

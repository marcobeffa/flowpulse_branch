class RemoveStructureFromBranches < ActiveRecord::Migration[8.0]
  def change
    remove_column :branches, :structure, :boolean
  end
end

class AddStructureToBranches < ActiveRecord::Migration[8.0]
  def change
    add_column :branches, :structure, :boolean, default: false, null: false
  end
end

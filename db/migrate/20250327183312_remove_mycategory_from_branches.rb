class RemoveMycategoryFromBranches < ActiveRecord::Migration[8.0]
  def change
    remove_reference :branches, :mycategory, null: false, foreign_key: true
    add_column :branches, :icon, :string
  end
end

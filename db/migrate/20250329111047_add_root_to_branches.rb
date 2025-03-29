class AddRootToBranches < ActiveRecord::Migration[8.0]
  def change
    add_column :branches, :label, :boolean, default: false, null: false
  end
end

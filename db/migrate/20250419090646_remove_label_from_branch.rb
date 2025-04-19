class RemoveLabelFromBranch < ActiveRecord::Migration[8.0]
  def change
    remove_column :branches, :label, :boolean
  end
end

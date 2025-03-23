class AddFieldsToBranch < ActiveRecord::Migration[8.0]
  def change
    add_column :branches, :visibility, :integer
    add_column :branches, :published, :boolean, default: false
    add_column :branches, :stato, :integer
  end
end

class AddExtrafieldsToBranch < ActiveRecord::Migration[8.0]
  def change
    add_column :branches, :field, :boolean, default: false, null: false
    add_column :branches, :field_type, :integer
  end
end

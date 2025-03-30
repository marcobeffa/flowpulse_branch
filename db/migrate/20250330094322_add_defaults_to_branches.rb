class AddDefaultsToBranches < ActiveRecord::Migration[8.0]
  def change
    change_column_default :branches, :visibility, 0
    change_column_default :branches, :stato, 0
  end
end

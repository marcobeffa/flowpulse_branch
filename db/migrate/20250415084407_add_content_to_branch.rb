class AddContentToBranch < ActiveRecord::Migration[8.0]
  def change
    add_column :branches, :content, :boolean, default: true, null: false
  end
end

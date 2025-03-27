class DropCategoriesAndMycategories < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :mycategories, :categories
    drop_table :categories
    drop_table :mycategories
  end
end

class CreateMycategories < ActiveRecord::Migration[8.0]
  def change
    create_table :mycategories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.string :name
      t.string :icon
      t.text :description
      t.boolean :public

      t.timestamps
    end
  end
end

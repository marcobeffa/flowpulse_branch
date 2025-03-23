class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :slug
      t.integer :parent_id
      t.integer :position
      t.integer :content_id
      t.string :slug_note
      t.string :user_note_username
      t.integer :child_id
      t.references :mycategory, null: false, foreign_key: true

      t.timestamps
    end
  end
end

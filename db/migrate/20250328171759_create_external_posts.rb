class CreateExternalPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :external_posts do |t|
      t.references :branch, null: false, foreign_key: true
      t.string :api_variabile
      t.json :content

      t.timestamps
    end
  end
end

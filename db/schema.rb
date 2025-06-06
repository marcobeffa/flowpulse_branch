# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_19_090736) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "branches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "slug"
    t.integer "parent_id"
    t.integer "position"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visibility", default: 0
    t.boolean "published", default: false
    t.integer "stato", default: 0
    t.datetime "updated_content"
    t.jsonb "content"
    t.boolean "field", default: false, null: false
    t.integer "field_type"
    t.index ["user_id"], name: "index_branches_on_user_id"
  end

  create_table "external_posts", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.string "api_variabile"
    t.json "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_external_posts_on_branch_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "username"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "branches", "users"
  add_foreign_key "external_posts", "branches"
  add_foreign_key "sessions", "users"
end

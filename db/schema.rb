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

ActiveRecord::Schema[7.1].define(version: 2025_06_02_155528) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "house_ingredients", force: :cascade do |t|
    t.date "expiration_date"
    t.integer "quantity"
    t.string "unit"
    t.bigint "house_id", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_house_ingredients_on_house_id"
    t.index ["ingredient_id"], name: "index_house_ingredients_on_ingredient_id"
  end

  create_table "house_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "roles"
    t.bigint "user_id", null: false
    t.bigint "house_id", null: false
    t.index ["house_id"], name: "index_house_users_on_house_id"
    t.index ["user_id"], name: "index_house_users_on_user_id"
  end

  create_table "houses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "preservation_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients_recipes", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.string "unit"
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_ingredients_recipes_on_recipe_id"
  end

  create_table "kitchens", force: :cascade do |t|
    t.boolean "done"
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_kitchens_on_recipe_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "prompt"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.bigint "chat_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "rating"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "favorite", default: false
    t.string "duration"
    t.integer "number_of_ingredients"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.string "description"
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prompt_setting"
    t.string "name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "users"
  add_foreign_key "house_ingredients", "houses"
  add_foreign_key "house_ingredients", "ingredients"
  add_foreign_key "house_users", "houses"
  add_foreign_key "house_users", "users"
  add_foreign_key "ingredients_recipes", "recipes"
  add_foreign_key "kitchens", "recipes"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "recipes", "users"
  add_foreign_key "steps", "recipes"
end

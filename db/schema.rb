# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_21_125028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wishlist_invitees", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "wishlist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_wishlist_invitees_on_user_id"
    t.index ["wishlist_id"], name: "index_wishlist_invitees_on_wishlist_id"
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.string "name"
    t.uuid "wishlist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id"
  end

  create_table "wishlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "wishlist_invitees", "users"
  add_foreign_key "wishlist_invitees", "wishlists"
  add_foreign_key "wishlist_items", "wishlists"
  add_foreign_key "wishlists", "users"
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_04_135940) do

  create_table "app_categories", force: :cascade do |t|
    t.integer "category_id"
    t.integer "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_rating_items", force: :cascade do |t|
    t.integer "app_rating_id"
    t.integer "rating_item_id"
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_ratings", force: :cascade do |t|
    t.integer "app_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
  end

  create_table "app_tags", force: :cascade do |t|
    t.integer "app_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apps", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "available_since"
    t.string "mydata_membership"
    t.string "license"
    t.integer "user_id"
    t.string "image_url"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category"
    t.integer "category_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_categories", force: :cascade do |t|
    t.integer "post_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posting_tags", force: :cascade do |t|
    t.integer "post_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "weekly_id"
    t.integer "user_id"
    t.date "post_date"
    t.string "title"
    t.string "url"
    t.string "media_url"
    t.string "media_type"
    t.text "description"
    t.string "category"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lang"
    t.integer "author_id"
  end

  create_table "rating_items", force: :cascade do |t|
    t.string "title"
    t.string "group"
    t.string "info_url"
    t.string "string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "source_reports", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "source_id"
  end

  create_table "source_tags", force: :cascade do |t|
    t.integer "source_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "source_tools", force: :cascade do |t|
    t.integer "source_id"
    t.integer "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "status"
    t.integer "user_id"
    t.text "request"
    t.text "response"
    t.string "url"
  end

  create_table "statistics", force: :cascade do |t|
    t.integer "timestamp"
    t.string "url"
    t.string "source"
    t.integer "source_id"
    t.string "target"
    t.integer "target_id"
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lang"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lang"
    t.string "key"
    t.boolean "confirmed"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group"
    t.text "intro"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "full_name"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "password_digest"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeklies", force: :cascade do |t|
    t.date "release"
    t.text "intro"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monitored_channels"
    t.integer "new_users"
    t.integer "thanks"
    t.integer "thanked"
    t.integer "users"
    t.integer "channels"
    t.integer "postings"
    t.text "monitored_channel_names"
    t.text "invite"
    t.datetime "invite_date"
  end

  create_table "weekly_apps", force: :cascade do |t|
    t.integer "weekly_id"
    t.integer "app_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "media_url"
    t.string "media_type"
    t.integer "status"
    t.date "post_date"
  end

  create_table "weekly_internals", force: :cascade do |t|
    t.integer "weekly_id"
    t.string "lang"
    t.text "intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "locale_only", default: false
  end

end

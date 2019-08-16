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

ActiveRecord::Schema.define(version: 2019_07_20_163739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "full_name"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

end

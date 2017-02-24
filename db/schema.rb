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

ActiveRecord::Schema.define(version: 20170223231247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.boolean  "block",       default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "story_id"
    t.index ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
    t.index ["story_id"], name: "index_relationships_on_story_id", using: :btree
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "category_id"
    t.integer  "favorites_count", default: 0, null: false
    t.integer  "blocks_count",    default: 0, null: false
    t.index ["category_id"], name: "index_stories_on_category_id", using: :btree
    t.index ["user_id"], name: "index_stories_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "age_range"
    t.string   "link"
    t.string   "gender"
    t.string   "locale"
    t.string   "image"
    t.string   "picture"
    t.string   "timezone"
    t.datetime "updated_time"
    t.boolean  "verified"
    t.string   "email"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "favorites_count", default: 0, null: false
    t.integer  "blocks_count",    default: 0, null: false
  end

end

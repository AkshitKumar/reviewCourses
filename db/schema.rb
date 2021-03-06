# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160117101208) do

  create_table "courses", force: :cascade do |t|
    t.integer  "dept_id",    limit: 4
    t.string   "number",     limit: 255
    t.string   "name",       limit: 255
    t.string   "prof",       limit: 255
    t.integer  "credits",    limit: 4
    t.integer  "sem",        limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "depts", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.text     "label",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "owner_id",   limit: 4
    t.integer  "course_id",  limit: 4
    t.string   "notif_type", limit: 255
    t.string   "action",     limit: 255
    t.boolean  "read",       limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "profs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "dept",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating",          limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id",         limit: 4
    t.integer  "course_id",       limit: 4
    t.text     "grading",         limit: 65535
    t.text     "learning",        limit: 65535
    t.text     "apply",           limit: 65535
    t.text     "prerequisites",   limit: 65535
    t.text     "usefulforcareer", limit: 65535
    t.integer  "vote_count",      limit: 4
    t.integer  "upvote",          limit: 4
  end

  create_table "search_suggestions", force: :cascade do |t|
    t.string   "term",       limit: 255
    t.integer  "course_id",  limit: 4
    t.string   "term_type",  limit: 255
    t.integer  "popularity", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sems", force: :cascade do |t|
    t.string   "label",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "review_id",  limit: 4
    t.integer  "course_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end

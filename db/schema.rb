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

ActiveRecord::Schema.define(version: 20160101051916) do

<<<<<<< HEAD
  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.string   "prof"
    t.integer  "credits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauths", force: :cascade do |t|
    t.string   "only"
    t.string   "create"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
||||||| merged common ancestors
  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.string   "prof"
    t.integer  "credits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauths", force: :cascade do |t|
    t.string   "only"
    t.string   "create"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
=======
  create_table "admins", force: :cascade do |t|
    t.integer  "adminid",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer  "dept_id",    limit: 4
    t.string   "number",     limit: 255
    t.string   "name",       limit: 255
    t.string   "prof",       limit: 255
    t.integer  "credits",    limit: 4
    t.integer  "sem",        limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
>>>>>>> 1e07399d72f14457b2b77f9cf2d1ac23fc4068ba
  end

  create_table "depts", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.text     "label",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "profs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating",     limit: 4
    t.text     "comment",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id",    limit: 4
    t.integer  "course_id",  limit: 4
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

end

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

ActiveRecord::Schema.define(version: 20171126152750) do

  create_table "algorithms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "author"
    t.string "time_complexity"
    t.string "space_complexity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "datasets", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "file_path"
    t.string "file_size"
    t.integer "dimensions"
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experiments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "project_id"
    t.integer "algorithm_id"
    t.integer "setting_id"
    t.integer "dataset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["algorithm_id"], name: "index_experiments_on_algorithm_id"
    t.index ["dataset_id"], name: "index_experiments_on_dataset_id"
    t.index ["project_id"], name: "index_experiments_on_project_id"
    t.index ["setting_id"], name: "index_experiments_on_setting_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "owner"
    t.date "started_at"
    t.date "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "file_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscript_dependencies", force: :cascade do |t|
    t.integer "parent_script_id"
    t.integer "child_script_id"
    t.integer "algorithm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscript_instances", force: :cascade do |t|
    t.integer "subscript_id"
    t.integer "status"
    t.integer "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscripts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "author"
    t.string "file_path"
    t.string "filename"
    t.integer "algorithm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

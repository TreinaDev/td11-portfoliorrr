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

ActiveRecord::Schema[7.1].define(version: 2024_01_26_130624) do
  create_table "connections", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_profile_id", null: false
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_profile_id", "follower_id"], name: "index_connections_on_followed_profile_id_and_follower_id", unique: true
    t.index ["followed_profile_id"], name: "index_connections_on_followed_profile_id"
    t.index ["follower_id"], name: "index_connections_on_follower_id"
  end

  create_table "education_infos", force: :cascade do |t|
    t.string "institution"
    t.string "course"
    t.date "start_date"
    t.date "end_date"
    t.boolean "visibility", default: true
    t.integer "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_education_infos_on_profile_id"
  end

  create_table "job_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_job_categories_on_name", unique: true
  end

  create_table "personal_infos", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "phone"
    t.string "area"
    t.boolean "visibility"
    t.date "birth_date"
    t.string "zip_code"
    t.string "street_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_personal_infos_on_profile_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "professional_infos", force: :cascade do |t|
    t.string "company"
    t.string "position"
    t.date "start_date"
    t.date "end_date"
    t.integer "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visibility"
    t.index ["profile_id"], name: "index_professional_infos_on_profile_id"
  end

  create_table "profile_job_categories", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.integer "job_category_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_category_id", "profile_id"], name: "index_profile_job_categories_on_job_category_id_and_profile_id", unique: true
    t.index ["job_category_id"], name: "index_profile_job_categories_on_job_category_id"
    t.index ["profile_id"], name: "index_profile_job_categories_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "cover_letter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.integer "role", default: 0
    t.string "citizen_id_number"
    t.index ["citizen_id_number"], name: "index_users_on_citizen_id_number", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "connections", "profiles", column: "followed_profile_id"
  add_foreign_key "connections", "profiles", column: "follower_id"
  add_foreign_key "education_infos", "profiles"
  add_foreign_key "personal_infos", "profiles"
  add_foreign_key "posts", "users"
  add_foreign_key "professional_infos", "profiles"
  add_foreign_key "profile_job_categories", "job_categories"
  add_foreign_key "profile_job_categories", "profiles"
  add_foreign_key "profiles", "users"
end

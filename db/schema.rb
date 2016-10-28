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

ActiveRecord::Schema.define(version: 20161027151936) do

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",               default: false
    t.string   "token"
    t.integer  "security_permissions", default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "client_id"
    t.boolean  "active",       default: false
    t.string   "token"
    t.string   "email"
    t.string   "manager_name"
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["client_id"], name: "index_companies_on_client_id"
  end

  create_table "companies_projects", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "company_id"
    t.index ["company_id"], name: "index_companies_projects_on_company_id"
    t.index ["project_id"], name: "index_companies_projects_on_project_id"
  end

  create_table "companies_skills", id: false, force: :cascade do |t|
    t.integer "skill_id"
    t.integer "company_id"
    t.index ["company_id"], name: "index_companies_skills_on_company_id"
    t.index ["skill_id"], name: "index_companies_skills_on_skill_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "img"
    t.string   "link_img"
    t.string   "summary"
    t.text     "description"
    t.text     "improvements"
    t.string   "time_spent"
    t.string   "language",       default: "en"
    t.boolean  "active",         default: false
    t.boolean  "future_project", default: false
    t.datetime "project_date"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "projects_tech_tags", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "tech_tag_id"
    t.index ["project_id"], name: "index_projects_tech_tags_on_project_id"
    t.index ["tech_tag_id"], name: "index_projects_tech_tags_on_tech_tag_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.integer  "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tech_tags", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end

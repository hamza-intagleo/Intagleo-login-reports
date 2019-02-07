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

ActiveRecord::Schema.define(version: 20190130115230) do

  create_table "employee_data", force: :cascade do |t|
    t.string   "name"
    t.string   "employee_id"
    t.string   "designation"
    t.string   "department"
    t.string   "manager"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "emp_id"
    t.integer  "employee_datum_id"
    t.datetime "login_time"
    t.date     "login_date"
    t.string   "event_type"
    t.integer  "event_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["employee_datum_id"], name: "index_events_on_employee_datum_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "emp_id"
    t.float    "time_in_office"
    t.float    "time_out_office"
    t.string   "source"
    t.date     "report_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "time_sheets", force: :cascade do |t|
    t.date     "date"
    t.integer  "employee_datum_id"
    t.float    "productive_hours"
    t.string   "task_description"
    t.float    "break_hours"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["employee_datum_id"], name: "index_time_sheets_on_employee_datum_id"
  end

end

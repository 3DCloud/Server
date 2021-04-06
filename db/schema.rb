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

ActiveRecord::Schema.define(version: 2021_04_06_200930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "clients", id: :uuid, default: nil, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "secret_digest", null: false
    t.boolean "authorized", default: false, null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "device_name", null: false
    t.string "hardware_identifier", null: false
    t.boolean "is_portable_hardware_identifier", null: false
    t.datetime "last_seen", null: false
    t.uuid "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hardware_identifier"], name: "index_devices_on_hardware_identifier", unique: true
  end

  create_table "printer_definitions", force: :cascade do |t|
    t.string "name", null: false
    t.text "start_gcode"
    t.text "end_gcode"
    t.text "pause_gcode"
    t.text "resume_gcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "driver", null: false
  end

  create_table "printers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "printer_definition_id", null: false
    t.string "name", null: false
    t.bigint "device_id", null: false
    t.index ["device_id"], name: "index_printers_on_device_id", unique: true
    t.index ["printer_definition_id"], name: "index_printers_on_printer_definition_id"
  end

  add_foreign_key "devices", "clients"
  add_foreign_key "printers", "devices"
  add_foreign_key "printers", "printer_definitions"
end

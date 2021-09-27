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

ActiveRecord::Schema.define(version: 2021_09_27_154541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authorization_grants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "code_challenge", null: false
    t.string "authorization_code", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_authorization_grants_on_user_id"
  end

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
    t.index ["client_id", "hardware_identifier"], name: "index_devices_on_client_id_and_hardware_identifier", unique: true
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
    t.string "state", default: "unknown", null: false
    t.index ["device_id"], name: "index_printers_on_device_id", unique: true
    t.index ["printer_definition_id"], name: "index_printers_on_printer_definition_id"
  end

  create_table "prints", force: :cascade do |t|
    t.bigint "uploaded_file_id", null: false
    t.bigint "printer_id", null: false
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["printer_id"], name: "index_prints_on_printer_id"
    t.index ["uploaded_file_id"], name: "index_prints_on_uploaded_file_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "jti"
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["jti"], name: "index_sessions_on_jti", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_uploaded_files_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "sso_uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sso_uid"], name: "index_users_on_sso_uid", unique: true
  end

  create_table "web_socket_tickets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ticket", null: false
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket"], name: "index_web_socket_tickets_on_ticket", unique: true
    t.index ["user_id"], name: "index_web_socket_tickets_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authorization_grants", "users"
  add_foreign_key "devices", "clients"
  add_foreign_key "printers", "devices"
  add_foreign_key "printers", "printer_definitions"
  add_foreign_key "prints", "printers"
  add_foreign_key "prints", "uploaded_files"
  add_foreign_key "sessions", "users"
  add_foreign_key "uploaded_files", "users"
  add_foreign_key "web_socket_tickets", "users"
end

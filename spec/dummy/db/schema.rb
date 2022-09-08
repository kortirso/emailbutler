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

ActiveRecord::Schema[7.0].define(version: 2022_09_08_180903) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "emailbutler_events", force: :cascade do |t|
    t.integer "emailbutler_message_id", null: false
    t.integer "status", null: false
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emailbutler_message_id"], name: "index_emailbutler_events_on_emailbutler_message_id"
  end

  create_table "emailbutler_messages", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "mailer", null: false
    t.string "action", null: false
    t.jsonb "params", default: {}, null: false
    t.string "send_to", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_emailbutler_messages_on_uuid", unique: true
  end

end

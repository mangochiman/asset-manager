# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_11_18_115215) do

  create_table "asset_activities", primary_key: "asset_activity_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "asset_id"
    t.string "name"
    t.datetime "checkout_date"
    t.integer "checkout_indefinite"
    t.datetime "return_on"
    t.datetime "checkin_date"
    t.integer "person_id"
    t.integer "location_id"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "asset_attachments", primary_key: "asset_attachment_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "asset_id"
    t.string "name"
    t.string "url"
    t.string "size"
    t.integer "bytes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "asset_reservations", primary_key: "asset_reservation_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "asset_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "person_id"
    t.integer "location_id"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "asset_service_logs", primary_key: "asset_service_log_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "service_item_id"
    t.integer "asset_id"
    t.datetime "start_date_actual"
    t.datetime "start_date_expected"
    t.datetime "end_date_actual"
    t.datetime "end_date_expected"
    t.integer "service_indefinite"
    t.integer "available_on_date"
    t.string "state"
    t.string "performed_by"
    t.integer "vendor_id"
    t.integer "person_id"
    t.text "notes"
    t.decimal "cost", precision: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "asset_service_schedules", primary_key: "asset_service_schedule_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "service_item_id"
    t.integer "asset_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "service_indefinite"
    t.string "performed_by"
    t.integer "vendor_id"
    t.integer "person_id"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "asset_types", primary_key: "asset_type_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "assets", primary_key: "asset_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "barcode"
    t.integer "asset_type_id"
    t.integer "status_id"
    t.integer "location_id"
    t.integer "condition_id"
    t.integer "vendor_id"
    t.string "serial_number"
    t.string "manufacturer"
    t.string "brand"
    t.string "model"
    t.decimal "unit_price", precision: 10
    t.date "date_purchased"
    t.string "order_number"
    t.string "account_code"
    t.date "warranty_end"
    t.text "notes"
    t.string "photo_url"
    t.integer "retired"
    t.string "retire_reason"
    t.date "date_retired"
    t.integer "retired_by"
    t.string "retire_comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exports", primary_key: "export_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "export_date"
    t.integer "bytes"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", primary_key: "group_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", primary_key: "location_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "password_reminders", primary_key: "password_reminder_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "password"
    t.string "salt"
    t.integer "voided", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", primary_key: "person_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "barcode"
    t.integer "location_id"
    t.integer "group_id"
    t.integer "selection_field_id"
    t.string "email"
    t.text "notes"
    t.string "phone"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "person_attachments", primary_key: "person_attachment_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "person_id"
    t.string "name"
    t.string "url"
    t.string "size"
    t.integer "bytes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "report_options", primary_key: "report_option_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "header"
    t.string "footer"
    t.string "logo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "selection_fields", primary_key: "selection_field_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "field_name"
    t.string "field_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "service_items", primary_key: "service_item_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "selection_field_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "system_activities", primary_key: "system_activities_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "person_id"
    t.string "action"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "system_plans", primary_key: "system_plan_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "company_id"
    t.string "subscription_plan"
    t.integer "assets_quota"
    t.integer "storage_quota"
    t.integer "admin_quota"
    t.integer "user_quota"
    t.string "company_name"
    t.string "billing_email"
    t.integer "active"
    t.decimal "cost_per_month", precision: 10
    t.decimal "addition_admin_cost", precision: 10
    t.string "currency_symbol"
    t.string "currency_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", primary_key: "user_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "person_id"
    t.string "username"
    t.string "password"
    t.string "salt"
    t.string "secret_question"
    t.string "secret_answer"
    t.integer "voided", default: 0
    t.integer "voided_by"
    t.date "date_voided"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vendor_attachments", primary_key: "vendor_attachment_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "vendor_id"
    t.string "name"
    t.string "url"
    t.string "size"
    t.integer "bytes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vendors", primary_key: "vendor_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "phone"
    t.string "website"
    t.string "contact_name"
    t.string "email"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end

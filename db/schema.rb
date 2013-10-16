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

ActiveRecord::Schema.define(version: 20131016093353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.string   "name",               null: false
    t.text     "bio"
    t.string   "soundcloud_url"
    t.string   "facebook_url"
    t.string   "twitter"
    t.string   "beatport_url"
    t.string   "website_url"
    t.string   "email"
    t.string   "country"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",    null: false
    t.datetime "deleted_at"
  end

  create_table "campaigns", force: true do |t|
    t.integer  "release_id"
    t.string   "name",          null: false
    t.string   "email_subject", null: false
    t.string   "email_from",    null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaigns", ["release_id"], name: "index_campaigns_on_release_id", using: :btree

  create_table "contact_lists", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "contact_lists", ["organization_id"], name: "index_contact_lists_on_organization_id", using: :btree

  create_table "contacts", force: true do |t|
    t.integer  "contact_list_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "contacts", ["contact_list_id"], name: "index_contacts_on_contact_list_id", using: :btree
  add_index "contacts", ["email", "contact_list_id", "deleted_at"], name: "contact_list_contact", unique: true, using: :btree

  create_table "email_logs", force: true do |t|
    t.string   "message_id"
    t.integer  "campaign_id"
    t.string   "to",             default: [],    array: true
    t.string   "from"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.boolean  "bounced",        default: false
    t.boolean  "marked_as_spam", default: false
    t.string   "clicked_links",  default: [],    array: true
  end

  add_index "email_logs", ["campaign_id"], name: "index_email_logs_on_campaign_id", using: :btree
  add_index "email_logs", ["message_id"], name: "index_email_logs_on_message_id", unique: true, using: :btree
  add_index "email_logs", ["to"], name: "index_email_logs_on_to", using: :btree

  create_table "feedbacks", force: true do |t|
    t.integer  "release_id"
    t.integer  "user_id"
    t.integer  "subscriber_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["release_id"], name: "index_feedbacks_on_release_id", using: :btree
  add_index "feedbacks", ["subscriber_id"], name: "index_feedbacks_on_subscriber_id", using: :btree
  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "import_rows", force: true do |t|
    t.integer  "import_id"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "header",     default: false, null: false
    t.string   "columns",    default: [],    null: false, array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_rows", ["import_id", "position"], name: "index_import_rows_on_import_id_and_position", unique: true, using: :btree
  add_index "import_rows", ["import_id"], name: "index_import_rows_on_import_id", using: :btree

  create_table "imports", force: true do |t|
    t.string   "spreadsheet_file_name"
    t.string   "spreadsheet_content_type"
    t.integer  "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.integer  "context_id"
    t.string   "context_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "catid"
    t.string   "style"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_street"
    t.string   "contact_phone"
    t.string   "contact_zipcode_city"
    t.string   "contact_url"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",      null: false
    t.datetime "deleted_at"
  end

  create_table "mandrill_events", force: true do |t|
    t.text     "json_payload"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_log_id"
  end

  add_index "mandrill_events", ["email_log_id"], name: "index_mandrill_events_on_email_log_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "feedback_id"
    t.integer  "track_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["feedback_id"], name: "index_ratings_on_feedback_id", using: :btree
  add_index "ratings", ["track_id"], name: "index_ratings_on_track_id", using: :btree

  create_table "release_artists", force: true do |t|
    t.integer  "release_id", null: false
    t.integer  "artist_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "release_artists", ["artist_id"], name: "index_release_artists_on_artist_id", using: :btree
  add_index "release_artists", ["release_id", "artist_id"], name: "index_release_artists_on_release_id_and_artist_id", unique: true, using: :btree
  add_index "release_artists", ["release_id"], name: "index_release_artists_on_release_id", using: :btree

  create_table "releases", force: true do |t|
    t.integer  "label_id",            null: false
    t.string   "title",               null: false
    t.string   "catid"
    t.string   "style"
    t.date     "date"
    t.text     "description"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",     null: false
    t.datetime "deleted_at"
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
  end

  add_index "releases", ["label_id"], name: "index_releases_on_label_id", using: :btree

  create_table "subscribers", force: true do |t|
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true, using: :btree

  create_table "tracks", force: true do |t|
    t.integer  "release_id"
    t.integer  "position"
    t.string   "artist"
    t.string   "title"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",         null: false
    t.datetime "deleted_at"
    t.integer  "length"
    t.integer  "bitrate"
    t.integer  "sample_rate"
    t.integer  "channels"
  end

  add_index "tracks", ["release_id"], name: "index_tracks_on_release_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                            null: false
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",                                 null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

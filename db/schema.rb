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

ActiveRecord::Schema.define(version: 20130422192549) do

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
  end

  create_table "contact_lists", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_lists", ["organization_id"], name: "index_contact_lists_on_organization_id"

  create_table "contacts", force: true do |t|
    t.integer  "contact_list_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["contact_list_id"], name: "index_contacts_on_contact_list_id"
  add_index "contacts", ["email", "contact_list_id"], name: "index_contacts_on_email_and_contact_list_id", unique: true
  add_index "contacts", ["first_name", "last_name"], name: "contact_name"

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
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "release_artists", force: true do |t|
    t.integer  "release_id", null: false
    t.integer  "artist_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "release_artists", ["artist_id"], name: "index_release_artists_on_artist_id"
  add_index "release_artists", ["release_id", "artist_id"], name: "index_release_artists_on_release_id_and_artist_id", unique: true
  add_index "release_artists", ["release_id"], name: "index_release_artists_on_release_id"

  create_table "releases", force: true do |t|
    t.integer  "label_id",           null: false
    t.string   "title",              null: false
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
    t.integer  "organization_id",    null: false
  end

  add_index "releases", ["label_id"], name: "index_releases_on_label_id"

  create_table "subscribers", force: true do |t|
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true

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
  end

  add_index "tracks", ["release_id"], name: "index_tracks_on_release_id"

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

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

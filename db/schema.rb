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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140829192911) do

  create_table "caps", :force => true do |t|
    t.string   "number"
    t.integer  "municipality_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "db_comuni_pictures", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "picturable_id"
    t.string   "picturable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "db_comuni_pictures", ["picturable_id", "picturable_type"], :name => "index_db_comuni_pictures_on_picturable_id_and_picturable_type"

  create_table "fractions", :force => true do |t|
    t.string   "name"
    t.string   "name_encoded"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "municipality_id"
    t.integer  "region_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "fractions", ["name_encoded", "region_id"], :name => "index_fractions_on_name_encoded_and_region_id"
  add_index "fractions", ["name_encoded"], :name => "index_fractions_on_name_encoded"

  create_table "municipalities", :force => true do |t|
    t.integer  "province_id"
    t.integer  "region_id"
    t.string   "name"
    t.string   "name_encoded"
    t.string   "president"
    t.integer  "population"
    t.float    "density"
    t.float    "surface"
    t.string   "istat_code"
    t.string   "cadastral_code"
    t.string   "telephone_prefix"
    t.string   "email"
    t.string   "website"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "municipalities", ["name_encoded", "region_id"], :name => "index_municipalities_on_name_encoded_and_region_id"
  add_index "municipalities", ["name_encoded"], :name => "index_municipalities_on_name_encoded"

  create_table "provinces", :force => true do |t|
    t.integer  "region_id"
    t.string   "name"
    t.string   "president"
    t.integer  "population"
    t.float    "density"
    t.float    "surface"
    t.string   "abbreviation"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name_encoded"
  end

  add_index "provinces", ["name_encoded", "region_id"], :name => "index_provinces_on_name_encoded_and_region_id"
  add_index "provinces", ["name_encoded"], :name => "index_provinces_on_name_encoded"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "name_encoded"
    t.integer  "capital_id"
    t.string   "president"
    t.integer  "population"
    t.float    "density"
    t.float    "surface"
    t.string   "abbreviation"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "regions", ["name_encoded"], :name => "index_regions_on_name_encoded"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end

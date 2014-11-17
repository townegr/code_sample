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

ActiveRecord::Schema.define(version: 20140925191107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chefs", force: true do |t|
    t.string   "name",        null: false
    t.string   "image"
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "specialties"
    t.text     "restaurants"
    t.string   "city"
    t.string   "state"
    t.text     "cookbooks"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "contact_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.datetime "start_at"
    t.datetime "expire_at"
    t.string   "status"
    t.integer  "percentage_off"
    t.decimal  "dollar_off",     precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "early_adopters", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  create_table "gift_purchases", force: true do |t|
    t.integer  "gift_id"
    t.string   "purchaser_email"
    t.string   "purchaser_name"
    t.text     "gift_message"
    t.datetime "send_at"
    t.string   "recipient_email"
    t.string   "recipient_name"
    t.decimal  "value",           precision: 5, scale: 2, null: false
    t.string   "token"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_token"
  end

  create_table "gift_redemptions", force: true do |t|
    t.integer  "gift_purchase_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "gifts", force: true do |t|
    t.string   "name",                                null: false
    t.text     "description"
    t.decimal  "value",       precision: 5, scale: 2, null: false
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "health_benefits", force: true do |t|
    t.string "name", null: false
  end

  create_table "health_benefits_recipes", id: false, force: true do |t|
    t.integer "health_benefit_id"
    t.integer "recipe_id"
  end

  add_index "health_benefits_recipes", ["health_benefit_id"], name: "index_health_benefits_recipes_on_health_benefit_id", using: :btree
  add_index "health_benefits_recipes", ["recipe_id"], name: "index_health_benefits_recipes_on_recipe_id", using: :btree

  create_table "ingredients", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipe_id"
  end

  add_index "ingredients", ["recipe_id"], name: "index_ingredients_on_recipe_id", using: :btree

  create_table "instructions", force: true do |t|
    t.integer  "recipe_id",   null: false
    t.integer  "step_number", null: false
    t.string   "image"
    t.string   "title"
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructions", ["recipe_id"], name: "index_instructions_on_recipe_id", using: :btree

  create_table "menu_items", force: true do |t|
    t.integer "recipe_id"
    t.integer "menu_id"
    t.integer "priority"
  end

  add_index "menu_items", ["recipe_id", "menu_id"], name: "index_menu_items_on_recipe_id_and_menu_id", using: :btree

  create_table "menus", force: true do |t|
    t.datetime "start_at",   null: false
    t.datetime "end_at",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "newsletter_subscriptions", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "tracking_number"
    t.decimal  "price",                    precision: 5, scale: 2
    t.decimal  "amount_charged",           precision: 5, scale: 2
    t.string   "shipping_label"
    t.string   "shipping_tracking_number"
    t.integer  "order_number"
    t.integer  "coupon_id"
    t.string   "coupon_code"
  end

  add_index "orders", ["menu_id"], name: "index_orders_on_menu_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "orders_recipes", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "recipe_id"
  end

  add_index "orders_recipes", ["order_id", "recipe_id"], name: "index_orders_recipes_on_order_id_and_recipe_id", using: :btree

  create_table "prep_needs", force: true do |t|
    t.string   "name"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string   "title",             null: false
    t.text     "description",       null: false
    t.string   "image",             null: false
    t.integer  "calories"
    t.string   "difficulty"
    t.integer  "chef_id"
    t.integer  "servings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "carbs"
    t.integer  "fat"
    t.integer  "protein"
    t.string   "ingredients_image"
    t.string   "featured_image"
    t.string   "prep_time"
  end

  add_index "recipes", ["chef_id"], name: "index_recipes_on_chef_id", using: :btree

  create_table "social_links", force: true do |t|
    t.integer  "chef_id"
    t.string   "social_type", null: false
    t.string   "url",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_links", ["chef_id"], name: "index_social_links_on_chef_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name",                       null: false
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                            default: "",    null: false
    t.string   "encrypted_password",                               default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                    default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "image"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "stripe_customer_id"
    t.integer  "stripe_cc_last_four"
    t.string   "stripe_cc_type"
    t.integer  "stripe_cc_exp_month"
    t.integer  "stripe_cc_exp_year"
    t.string   "stripe_token"
    t.decimal  "credit",                   precision: 5, scale: 2, default: 0.0,   null: false
    t.boolean  "is_residential",                                   default: true
    t.boolean  "is_blocked_from_ordering",                         default: false
    t.string   "phone"
    t.integer  "account_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

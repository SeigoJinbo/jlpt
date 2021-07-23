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

ActiveRecord::Schema.define(version: 2021_04_15_010751) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kanji_words", force: :cascade do |t|
    t.bigint "kanji_id", null: false
    t.bigint "word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kanji_id"], name: "index_kanji_words_on_kanji_id"
    t.index ["word_id"], name: "index_kanji_words_on_word_id"
  end

  create_table "kanjis", force: :cascade do |t|
    t.string "character"
    t.string "slug"
    t.integer "jlpt"
    t.string "radical", array: true
    t.string "definition"
    t.string "kun"
    t.string "on"
    t.json "compounds"
    t.string "parts", array: true
    t.string "variants", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "strokes"
  end

  create_table "words", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "jlpt"
    t.json "definition"
    t.string "furigana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "kanji_words", "kanjis"
  add_foreign_key "kanji_words", "words"
end

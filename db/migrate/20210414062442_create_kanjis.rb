class CreateKanjis < ActiveRecord::Migration[6.0]
  def change
    create_table :kanjis do |t|
      t.string :character
      t.string :slug
      t.integer :jlpt
      t.string :radical, array: true
      t.string :definition
      t.string :kun
      t.string :on
      t.json :compounds
      t.string :parts, array: true
      t.string :variants, array: true

      t.timestamps
    end
  end
end

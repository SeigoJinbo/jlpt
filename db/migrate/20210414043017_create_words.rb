class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :text
      t.string :slug
      t.integer :jlpt
      t.json :definition
      t.string :furigana

      t.timestamps
    end
  end
end

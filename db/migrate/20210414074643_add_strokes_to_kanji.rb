class AddStrokesToKanji < ActiveRecord::Migration[6.0]
  def change
    add_column :kanjis, :strokes, :integer
  end
end

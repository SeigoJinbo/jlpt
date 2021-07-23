class KanjiSerializer
  include FastJsonapi::ObjectSerializer
  attributes :character,
             :definition,
             :kun,
             :on,
             :strokes,
             :parts,
             :variants,
             :radical,
             :jlpt,
             :compounds,
             :slug
  has_many :kanji_words
  has_many :words, through: :kanji_words
end

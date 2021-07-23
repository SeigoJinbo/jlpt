class WordSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :jlpt, :definition, :furigana, :slug

  has_many :kanjis, through: :kanji_words
end

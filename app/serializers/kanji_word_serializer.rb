class KanjiWordSerializer
  include FastJsonapi::ObjectSerializer
  attributes :kanji_id, :word_id
end

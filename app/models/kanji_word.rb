class KanjiWord < ApplicationRecord
  belongs_to :kanji
  belongs_to :word
end

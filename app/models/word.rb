class Word < ApplicationRecord
  has_many :kanji_words, dependent: :destroy
  has_many :kanjis, through: :kanji_words

  before_create :slugify
  def slugify
    self.slug =
      name.force_encoding('ASCII-8BIT').bytes.map do |byte|
        "%#{byte.to_s(16).upcase}"
      end.join('')
  end
end

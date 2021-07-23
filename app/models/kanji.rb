class Kanji < ApplicationRecord
  has_many :kanji_words, dependent: :destroy
  has_many :words, through: :kanji_words

  before_create :slugify
  def slugify
    self.slug =
      character.force_encoding('ASCII-8BIT').bytes.map do |byte|
        "%#{byte.to_s(16).upcase}"
      end.join('')
  end
end

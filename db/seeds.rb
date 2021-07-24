require 'nokogiri'
require 'httparty'
# require 'byebug'
require 'open-uri'

# Word.select {|word|word.definition.values.map{|item| item['meaning']}.join('').include?('change')}

def damnation
  puts 'clearing database...'
  KanjiWord.destroy_all
  Word.destroy_all
  Kanji.destroy_all
end

damnation if false

word_list = %w[大変 意見 大体 相変わらず]
N5LIST = []
N4LIST = []

def wiki_scraper(level)
  output = []
  url = "https://en.wiktionary.org/wiki/Appendix:JLPT/N#{level}"
  unparsed_page = URI.open(url)
  parsed_page = Nokogiri.HTML(unparsed_page)
  list = parsed_page.css('div.mw-parser-output').css('li')
  list.each do |item|
    if item.css('a').any?
      output << item.css('a').first.text
      puts "adding #{item.css('a').first.text} to the list"
    else
      output << item.text.slice(/[|]\W+}/).slice(1..-3)
      puts "adding #{item.text.slice(/[|]\W+}/).slice(1..-3)} to the list"
    end
  end
  output
end

def wiki_scraper_n1(level)
  output = []
  url = "https://en.wiktionary.org/wiki/Appendix:JLPT/N1/#{level}"
  unparsed_page = URI.open(url)
  parsed_page = Nokogiri.HTML(unparsed_page)
  list = parsed_page.css('div.mw-parser-output').css('li')
  list.each do |item|
    if item.css('a').any?
      output << item.css('a').first.text
      puts "adding #{item.css('a').first.text} to the list"
    else
      output << item.text.slice(/[|]\W+}/).slice(1..-3)
      puts "adding #{item.text.slice(/[|]\W+}/).slice(1..-3)} to the list"
    end
  end
  output
end

def converter(input)
  input.force_encoding('ASCII-8BIT').bytes.map do |byte|
    "%#{byte.to_s(16).upcase}"
  end.join('')
end

def word_scraper(search)
  if Word.where(name: search).blank?
    word = converter(search)
    url = "https://jisho.org/search/#{word}"
    unparsed_page = URI.open(url)
    parsed_page = Nokogiri.HTML(unparsed_page)
    name =
      parsed_page.css('div.concept_light-representation').first.css('span.text')
        .text.strip
    furigana =
      parsed_page.css('div.concept_light-representation').first.css(
        'span.furigana'
      ).text.strip
    if parsed_page.css('span.concept_light-tag.label')
      jlpt =
        (
          parsed_page.css('span.concept_light-tag.label').text.strip.slice(
            /[JLPT N]\d/
          ) || ''
        ).slice(/\d/).to_i
    end
    definition = {}
    parsed_page.css('div.exact_block').css('div.meaning-tags')
      .each_with_index do |item, index|
      if !parsed_page.css('div.exact_block').css('span.meaning-meaning')[index]
           .nil?
        definition[index] = {
          type: item.text,
          meaning:
            parsed_page.css('div.exact_block').css('span.meaning-meaning')[
              index
            ].text.strip
        }
      else
        definition[index] = {
          type: item.text,
          meaning:
            parsed_page.css('div.exact_block').css('div.meaning-definition')[
              index
            ].text.strip
        }
      end
    end

    Word.create!(
      name: name, furigana: furigana, jlpt: jlpt, definition: definition
    )
    puts "successfully created word: #{search}..."
  else
    puts "#{search} already exists..."
  end
end

def kanji_scraper(word)
  puts "processing kanji for #{word.name}"
  name = word.name
  word.name.chars.each do |char|
    kanji = converter(char)
    if Kanji.where(character: char).blank?
      url = "https://jisho.org/search/#{kanji}%20%23kanji"
      unparsed_page = URI.open(url)
      parsed_page = Nokogiri.HTML(unparsed_page)
      if parsed_page.css('div.kanji.details').any?
        character = parsed_page.css('h1.character').text
        if !character.empty?
          definition =
            parsed_page.css('div.kanji-details__main-meanings').text.strip
          kun = parsed_page.css('dl.dictionary_entry.kun_yomi dd').text.strip
          on =
            parsed_page.css(
              'div.kanji-details__main-readings dl.dictionary_entry.on_yomi a'
            ).text.strip

          strokes =
            parsed_page.css('div.kanji-details__stroke_count strong').text.strip
              .to_i

          parts = []
          if parsed_page.css('div.radicals').any?
            parsed_page.css('div.radicals')[1].css('dd a').each do |item|
              parts << item.text.strip
            end
          end

          variants = []
          if parsed_page.css('dl.variants').any?
            parsed_page.css('dl.variants').css('dd a').each do |item|
              variants << item.text.strip
            end
          end
          radical = []

          radical <<
            parsed_page.at('div.radicals dd span').text.strip.slice(/\b\W\b/)
              .strip
          if parsed_page.at('div.radicals dd span').text.strip.slice(/\(.+/)
            radical <<
              parsed_page.at('div.radicals dd span').text.strip.slice(/\(.+/)
                .strip
          end

          if parsed_page.at('div.jlpt strong')
            jlpt = parsed_page.at('div.jlpt strong').text.strip.slice(/\d/).to_i
          else
            jlpt = 0
          end

          compounds = {}
          parsed_page.css('div.row.compounds div.small-12').each do |item|
            ul = []
            item.css('li').each { |li| ul << li.text.strip.gsub("\n", '') }
            compounds[item.css('h2').text] = ul
          end

          word.kanjis <<
            Kanji.create!(
              character: character,
              definition: definition,
              kun: kun,
              on: on,
              strokes: strokes,
              parts: parts,
              variants: variants,
              radical: radical,
              jlpt: jlpt,
              compounds: compounds
            )
          puts "successfully created kanji: #{char}"
        end
      end
      # elsif KanjiWord.where(word: word, kanji: kanji)
      #   puts 'attachment already exists'
    else
      word.kanjis << Kanji.where(character: char)
      puts "successfully attached existing kanji to #{word.name}"
    end
  end
end
# word_list.each { |word| word_scraper(word) }

# N5LIST[101..200].each { |word| word_scraper(word) }
# n5list = wiki_scraper(5)
# n5list.each { |word| word_scraper(word) }
# words = Word.all.where(jlpt: 5)
# words.each { |word| kanji_scraper(word) }

# n4list = wiki_scraper(4)
# n4list.each { |word| word_scraper(word) }
# words = Word.all.where(jlpt: 4)
# words[125..-1].each { |word| kanji_scraper(word) }

# n3list = wiki_scraper(3)
# n3list.each { |word| word_scraper(word) }
# words = Word.all.where(jlpt: 3)
# words.each { |word| kanji_scraper(word) }

n2list = wiki_scraper(2)
# n2list[0..71].each { |word| word_scraper(word) }
# n2list[73..629].each { |word| word_scraper(word) }
n2list[631..-1].each { |word| word_scraper(word) }
# words = Word.all.where(jlpt: 2)
# words[1201..-1].each { |word| kanji_scraper(word) }

# char = 'わ行'
# kanji = converter(char)
# n1list = wiki_scraper_n1(kanji)
# n1list.each { |word| word_scraper(word) }

# words = Word.all.where(jlpt: 1)
# words[1601..-1].each { |word| kanji_scraper(word) }

#error log n2: 72, 630 (start at 73, 631)

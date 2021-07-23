module Api
  module V1
    class WordsController < ApplicationController
      def index
        all_words = Word.all
        words = all_words[0..10]
        render json: WordSerializer.new(words, options).serialized_json
      end

      def show
        word = Word.find_by(name: params[:slug])
        render json: WordSerializer.new(word, options).serialized_json
      end

      private

      def word_params
        params.require(:word).permit(
          :name,
          :jlpt,
          :definition,
          :furigana,
          :slug
        )
      end

      def options
        @options ||= { include: %i[kanjis] }
      end
    end
  end
end

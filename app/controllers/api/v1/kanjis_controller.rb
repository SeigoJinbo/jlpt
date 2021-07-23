module Api
  module V1
    class KanjisController < ApplicationController
      def index
        kanjis = Kanji.all
        render json: WordSerializer.new(kanjis, options).serialized_json
      end

      def show
        kanji = Kanji.find_by(slug: params[:slug])
        render json: WordSerializer.new(kanji, options).serialized_json
      end

      private

      def word_params
        params.require(:kanji).permit(
          :character,
          :definition,
          :kun,
          :on,
          :strokes,
          :parts,
          :variants,
          :radical,
          :jlpt,
          :compounds
        )
      end

      def options
        @options ||= { include: %i[words] }
      end
    end
  end
end

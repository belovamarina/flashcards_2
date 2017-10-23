module Dashboard
  class CardParsersController < Dashboard::BaseController
    def new; end

    def create
      CardParserJob.perform_later(current_user.id, normalize(parser_params))
      redirect_to cards_path
    end

    def show; end

    private

    def parser_params
      params.permit(:url, :original_xpath, :translated_xpath, :block_id)
    end

    def normalize(params)
      params.to_h.symbolize_keys
    end
  end
end

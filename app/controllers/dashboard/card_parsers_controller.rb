module Dashboard
  class CardParsersController < Dashboard::BaseController
    def new; end

    def create
      @result = CardParserJob.perform_now(current_user, normalize(parser_params))
      if @result.present? && @result.is_a?(Array)
        render :show
      else
        redirect_to new_card_parser_path, alert: "Не удалось собрать карточки #{@result&.message}"
      end
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

module Dashboard
  class CardParsersController < Dashboard::BaseController
    def new; end

    def create
      job = CardParserJob.perform_later(current_user.id, normalize(parser_params))
      byebug
      @result = Card.where(created_at: 3.minutes.ago..Time.current)
      if job.present?
        render :show
      else
        redirect_to new_card_parser_path, alert: "Не удалось собрать карточки #{job}"
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

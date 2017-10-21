module Dashboard
  class CardParsersController < Dashboard::BaseController
    def new; end

    def create
      job = CardParserJob.perform_later(current_user.id, normalize(parser_params))
      redirect_to new_card_parser_path
      # errors = job_errors(job.provider_job_id)
      # if errors.blank? && new_cards.present?
      #   render :show
      # else
      #   redirect_to new_card_parser_path, alert: "Не удалось собрать карточки #{errors}"
      # end
    end

    def show; end

    private

    def new_cards
      @result = Card.where(created_at: 2.minutes.ago..Time.current)
    end

    def parser_params
      params.permit(:url, :original_xpath, :translated_xpath, :block_id)
    end

    def normalize(params)
      params.to_h.symbolize_keys
    end

    def job_errors(job_id)
      Delayed::Job.find(job_id).last_error[/\A.+$/] rescue nil
    end
  end
end

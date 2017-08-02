class Dashboard::TrainerController < Dashboard::BaseController
  before_action :set_card, if: :has_params_id?

  def index
    if current_user.current_block
      @card = current_user.current_block.cards.pending.first
      @card ||= current_user.current_block.cards.repeating.first
    else
      @card = current_user.cards.pending.first
      @card ||= current_user.cards.repeating.first
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def review_card
    check_result = @card.check_translation(trainer_params[:user_translation])

    if check_result[:state]
      if check_result[:distance] == 0
        flash[:notice] = t(:correct_translation_notice)
      else
        flash[:alert] = t 'translation_from_misprint_alert',
                          user_translation: trainer_params[:user_translation],
                          original_text: @card.original_text,
                          translated_text: @card.translated_text
      end
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end

  def has_params_id?
    params[:id] || params[:card_id]
  end
end

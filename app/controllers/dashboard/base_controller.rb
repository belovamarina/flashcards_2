module Dashboard
  class BaseController < ApplicationController
    before_action :require_login
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    protected

    def set_card
      @card = current_user.cards.find(params[:id] || params[:card_id])
    end

    private

    def not_authenticated
      redirect_to login_path, alert: t(:please_log_in)
    end

    def not_found
      flash[:alert] = 'Вы обратились к несуществующей записи.'
      redirect_to root_path
    end
  end
end

module Home
  class HomeController < Home::BaseController
    include RandomCard

    def index
      if params[:id]
        @card = current_user.cards.find(params[:id])
      else
        random_card
      end

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end

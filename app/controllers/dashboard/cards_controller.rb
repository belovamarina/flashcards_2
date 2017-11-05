module Dashboard
  class CardsController < Dashboard::BaseController
    before_action :set_card, only: %i(destroy edit update)
    respond_to :html

    def index
      @cards = current_user.cards.order('review_date')
    end

    def new
      @card = Card.new
    end

    def edit; end

    def create
      @card = current_user.cards.build(card_params)
      if @card.save
        ahoy.track 'New card', title: "Created new card: #{@card.id}"
        redirect_to cards_path
      else
        respond_with @card
      end
    end

    def update
      if @card.update(card_params)
        redirect_to cards_path
      else
        respond_with @card
      end
    end

    def destroy
      @card.destroy
      respond_with @card
    end

    private

    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date,
                                   :image, :image_cache, :remove_image, :block_id, :remote_image_url)
    end
  end
end

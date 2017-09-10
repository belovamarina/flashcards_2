module RandomCard
  extend ActiveSupport::Concern

  def random_card
    return unless current_user
    @card = if current_user.current_block
              current_user.current_block.cards.pending.first || current_user.current_block.cards.repeating.first
            else
              current_user.cards.pending.first || current_user.cards.repeating.first
            end
  end
end

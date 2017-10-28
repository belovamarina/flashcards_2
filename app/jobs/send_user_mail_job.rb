class SendUserMailJob < ApplicationJob
  queue_as :default

  def perform(email)
    CardsMailer.pending_cards_notification(email).deliver_now
  end
end

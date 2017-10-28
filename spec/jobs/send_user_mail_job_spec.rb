require 'rails_helper'
# config in: spec/support/active_job.rb

RSpec.describe SendUserMailJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'calls on the CardsMailer' do
      allow(CardsMailer).to receive_message_chain(:pending_cards_notification, :deliver_now)

      described_class.perform_later(user.email)

      expect(CardsMailer).to have_received(:pending_cards_notification)
    end
  end
end

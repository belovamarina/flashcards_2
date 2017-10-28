require 'rails_helper'
# config in: spec/support/active_job.rb

RSpec.describe CardParserJob, type: :job do
  describe '.perform_later' do
    let(:user) { create(:user) }

    it 'adds the job to the queue' do
      described_class.perform_later(user.id, {})
      expect(performed_jobs.last[:job]).to eq described_class
    end
  end
end

require 'rails_helper'

RSpec.feature 'Access to API main page', type: :feature do
  let(:user) { create(:user) }

  scenario 'user login with HTTP Basic auth' do
    page.driver.browser.basic_authorize(user.email, '12345')
    visit api_flashcards_path
    expect(page).to have_content 'Welcome'
  end

  scenario 'anonim try to visit api page' do
    visit api_flashcards_path
    expect(page).not_to have_content 'Welcome'
  end
end

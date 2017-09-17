require 'rails_helper'

RSpec.feature 'Access to admin dashboard', type: :feature do
  let(:user) { create(:user) }
  let(:user_admin) { create(:user_admin) }

  scenario 'anonim try visit admin dashboard' do
    visit rails_admin_path
    expect(page).to have_content 'Вход'
  end

  scenario 'not admin try to visit admin dashboard' do
    visit login_path
    login(user, 'Войти')

    visit rails_admin_path
    expect(page).to have_content 'You are not authorized'
  end

  scenario 'admin visit dashboard' do
    visit login_path
    login(user_admin, 'Войти')

    visit rails_admin_path
    expect(page).to have_content 'Управление сайтом'
  end
end

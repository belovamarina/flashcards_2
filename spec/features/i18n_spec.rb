require 'rails_helper'

RSpec.feature 'User change language', type: :feature do
  before do
    visit root_path
  end

  scenario 'home page' do
    click_link 'en'
    expect(page).to have_content 'Welcome.'
  end

  scenario 'register TRUE' do
    click_link 'en'
    register(build(:user, locale: ''), 'Sing up')
    expect(page).to have_content 'User created successfully.'
  end

  scenario 'default locale' do
    click_link 'en'
    user = build(:user)
    register(user, 'Sing up')
    user = User.find_by_email(user.email)
    expect(user.locale).to eq('en')
  end

  it 'available locale' do
    click_link 'en'
    register(build(:user), 'Sing up')
    click_link 'User profile'
    fill_in 'user[password]', with: '12345'
    fill_in 'user[password_confirmation]', with: '12345'
    click_button 'Сохранить'
    expect(page).to have_content 'Профиль пользователя успешно обновлен.'
  end

  it 'authentication TRUE' do
    user = create(:user)
    click_link 'en'
    login(user, 'Log in')
    expect(page).to have_content 'Login is successful.'
  end
end

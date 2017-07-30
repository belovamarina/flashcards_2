require 'rails_helper'

RSpec.feature 'User authentication', type: :feature do
  before do
    visit root_path
  end

  let!(:user) { create(:user) }

  scenario 'require_login root' do
    expect(page).to have_content 'Добро пожаловать.'
  end

  scenario 'authentication TRUE' do
    login(user, 'Войти')
    expect(page).to have_content 'Вход выполнен успешно.'
  end

  scenario 'incorrect e-mail' do
    login(user, '1@1.com', user.password, 'Войти')
    expect(page)
      .to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
  end

  scenario 'incorrect password' do
    login(user, user.email, '56789', 'Войти')
    expect(page)
      .to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
  end

  scenario 'incorrect e-mail and password' do
    login(user, '1@1.com', '56789', 'Войти')
    expect(page)
      .to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
  end
end

require 'rails_helper'

RSpec.feature 'User Registration', type: :feature do
  before do
    visit root_path
  end

  scenario 'valid user register' do
    register(build(:user), 'Зарегистрироваться')
    expect(page).to have_content 'Пользователь успешно создан.'
  end

  scenario 'fail password confirmation' do
    register(build(:user, password_confirmation: '56789'), 'Зарегистрироваться')
    expect(page).to have_content 'Значения не совпадают.'
  end

  scenario 'wrong email format' do
    register(build(:user, email: 'test'), 'Зарегистрироваться')
    expect(page).to have_content 'Не верный формат.'
  end

  scenario 'password is too short' do
    user = build(:user, password: '1', password_confirmation: '1')
    register(user, 'Зарегистрироваться')
    expect(page).to have_content 'Короткое значение.'
  end


   scenario 'password_confirmation is too short' do
     user = build(:user, password_confirmation: '2')
     register(user, 'Зарегистрироваться')
     expect(page).to have_content 'Значения не совпадают.'
   end

  scenario 'not uniq email' do
    user = build(:user, email: 'test@test.com')
    register(user, 'Зарегистрироваться')
    click_link 'Выйти'
    register(user, 'Зарегистрироваться')
    expect(page).to have_content 'Не уникальное значение.'
  end
end

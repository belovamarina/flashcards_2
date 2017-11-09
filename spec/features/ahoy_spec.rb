require 'rails_helper'

RSpec.feature 'Tracking visits and events', type: :feature do
  let(:user) { create(:user, :with_blocks_and_card) }

  before do
    visit login_path
    login(user, 'Войти')
  end

  scenario 'tracking login' do
    events = Ahoy::Event.where(name: 'sessions_create')
    expect(events).not_to be_empty
  end

  scenario 'tracking card creation' do
    visit new_card_path
    fill_in 'card[original_text]', with: 'CatDog'
    fill_in 'card[translated_text]', with: 'Котопес'
    select 'Block 1', from: 'card[block_id]'
    click_button 'Сохранить'

    event = Ahoy::Event.where(name: 'cards_create').last
    expect(event.properties['title']).to match('Created new card')
  end

  scenario 'tracking user train' do
    visit trainer_path
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'

    event = Ahoy::Event.where(name: 'trainer_card_review').last
    expect(event.properties['title']).to match('house')
  end
end

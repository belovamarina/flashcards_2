require 'rails_helper'

RSpec.feature 'User card trainer', type: :feature do
  feature 'review cards without blocks' do
    scenario 'training without cards' do
      user = create(:user)
      visit trainer_path
      login(user, 'Войти')
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  feature 'review cards with one block' do
    scenario 'training without cards' do
      user = create(:user_with_one_block_without_cards)
      visit trainer_path
      login(user, 'Войти')
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end

    feature 'training with two cards' do
      before do
        user = create(:user_with_one_block_and_two_cards)

        user.cards.each do |card|
          card.update_attribute(:review_date,
                                Time.now - 3.days)
        end

        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'user see page first time' do
        expect(page).to have_content 'Оригинал'
      end

      scenario 'incorrect translation' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
      end

      scenario 'correct translation distance=1' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели перевод c опечаткой.'
      end

      scenario 'incorrect translation distance=2' do
        fill_in 'user_translation', with: 'hou'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end
    end

    feature 'training with one card' do
      before do
        user = create(:user_with_one_block_and_one_card)
        user.cards.each do |card|
          card.update_attribute(:review_date,
                                Time.now - 3.days)
        end
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'incorrect translation' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end

      scenario 'incorrect translation distance=2' do
        fill_in 'user_translation', with: 'hou'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation distance=1' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели перевод c опечаткой.'
      end

      scenario 'correct translation quality=3' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        fill_in 'user_translation', with: 'House'
        click_button 'Проверить'
        expect(page).to have_content 'Текущая карточка'
      end

      scenario 'correct translation quality=4' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        fill_in 'user_translation', with: 'House'
        click_button 'Проверить'
        fill_in 'user_translation', with: 'House'
        click_button 'Проверить'
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end
    end
  end

  feature 'review cards with two blocks' do
    feature 'training without cards' do
      before do
        user = create(:user_with_two_blocks_without_cards)
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'no cards' do
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end
    end

    feature 'training with two cards' do
      before do
        user = create(:user_with_two_blocks_and_one_card_in_each)
        user.cards.each do |card|
          card.update_attribute(:review_date,
                                Time.now - 3.days)
        end
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'first visit' do
        expect(page).to have_content 'Оригинал'
      end

      scenario 'incorrect translation' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
      end

      scenario 'incorrect translation distance=2' do
        fill_in 'user_translation', with: 'hou'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation distance=1' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели перевод c опечаткой.'
      end
    end

    feature 'training with one card' do
      before do
        user = create(:user_with_two_blocks_and_only_one_card)
        user.cards.each do |card|
          card.update_attribute(:review_date,
                                Time.now - 3.days)
        end
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'incorrect translation' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end

      scenario 'incorrect translation distance=2' do
        fill_in 'user_translation', with: 'hou'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation distance=1' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели перевод c опечаткой.'
      end
    end
  end

  feature 'review cards with current_block' do
    feature 'training without cards' do
      before do
        user = create(:user_with_two_blocks_without_cards, current_block_id: 1)
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'no cards' do
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end
    end

    feature 'training with two cards' do
      before do
        user = create(:user_with_two_blocks_and_two_cards_in_each)
        block = user.blocks.first
        user.set_current_block(block)
        card = user.cards.find_by(block_id: block.id)
        card.update_attribute(:review_date, Time.now - 3.days)
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'first visit' do
        expect(page).to have_content 'Оригинал'
      end

      scenario 'incorrect translation' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
      end

      scenario 'incorrect translation distance=2' do
        fill_in 'user_translation', with: 'hou'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation distance=1' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content 'Вы ввели перевод c опечаткой.'
      end
    end

    feature 'training with one card' do
      before do
        user = create(:user_with_two_blocks_and_one_card_in_each)
        block = user.blocks.first
        user.set_current_block(block)
        card = user.cards.find_by(block_id: block.id)
        card.update_attribute(:review_date, Time.now - 3.days)
        visit trainer_path
        login(user, 'Войти')
      end

      scenario 'incorrect translation' do
        fill_in 'user_translation', with: 'RoR'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation' do
        fill_in 'user_translation', with: 'house'
        click_button 'Проверить'
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end

      scenario 'incorrect translation distance=2' do
        fill_in 'user_translation', with: 'hou'
        click_button 'Проверить'
        expect(page)
          .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
      end

      scenario 'correct translation distance=1' do
        fill_in 'user_translation', with: 'hous'
        click_button 'Проверить'
        expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
      end
    end
  end
end


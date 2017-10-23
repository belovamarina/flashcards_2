require 'rails_helper'
WebMock.allow_net_connect!

RSpec.feature 'Cards Parser' do
  before do
    user = create(:user, :with_blocks)
    visit new_card_parser_path
    login(user, 'Войти')
  end

  scenario 'user fills forms right' do
    stub_request(:get, /most_common_words_5.htm/)
        .to_return(body: File.new('./spec/support/most_common_words.html'), status: 200)

    page.fill_in 'url', with: 'http://masterrussian.com/vocabulary/most_common_words_5.htm'
    page.fill_in 'original_xpath', with: "//tr[@class='rowFirst']/td[@class='word']"
    page.fill_in 'translated_xpath', with: "//tr[@class='rowFirst']/td[3]"
    page.click_button 'Собрать карточки'
    expect(page).to have_content 'Редактировать'
  end

  scenario 'user enters invalid url' do
    stub_request(:get, /moooost_common_words_5.htm/).to_return(status: [404, 'Not Found'])

    fill_in 'url', with: 'http://masterrussian.com/vocabulary/moooost_common_words_5.htm'
    fill_in 'original_xpath', with: "//tr[@class='rowFirst']/td[@class='word']"
    fill_in 'translated_xpath', with: "//tr[@class='rowFirst']/td[3]"
    click_button 'Собрать карточки'
    expect(page).not_to have_content 'Редактировать'
  end

  scenario 'user enters invalid xpath' do
    stub_request(:get, /most_common_words_5.htm/)
        .to_return(body: File.new('./spec/support/most_common_words.html'), status: 200)

    fill_in 'url', with: 'http://masterrussian.com/vocabulary/most_common_words_5.htm'
    fill_in 'original_xpath', with: "//tr[@class='rowFirst']/td[@class='word']]"
    fill_in 'translated_xpath', with: "//tr[@class='rowFirst']/td[3]]"
    click_button 'Собрать карточки'
    expect(page).not_to have_content 'Редактировать'
  end
end

class CardParserJob < ApplicationJob
  queue_as :default

  def perform(user_id, url:, original_xpath:, translated_xpath:, block_id:)
    parser = CardParser.new(url, original_xpath, translated_xpath)
    words = parser.parse
    raise StandardError, "#{parser.error}" if parser.error
    build_cards(words, user_id, block_id)
  end

  private

  def build_cards(words, user_id, block_id)
    user = User.find(user_id)
    words.each do |pair|
      card = user.cards.build(original_text: pair.first,
                              translated_text: pair.last,
                              block_id: block_id)
      next unless card.valid?
      card.save
    end
  end
end

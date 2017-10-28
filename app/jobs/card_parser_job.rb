class CardParserJob < ApplicationJob
  queue_as :default
  rescue_from StandardError do |error|
    broadcast_message(message: "Не удалось собрать карточки: #{error.message}")
  end

  def perform(user_id, url:, original_xpath:, translated_xpath:, block_id:)
    parser = CardParser.new(url, original_xpath, translated_xpath)
    words = parser.parse
    raise StandardError, parser.error if parser.error
    build_cards(words, user_id, block_id)
    broadcast_message(message: 'Закончили собирать карточки')
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
      broadcast_message(message: '', card: "Карточка сохранена: #{pair.join(' - ')}")
    end
  end

  def broadcast_message(message: nil, card: nil)
    stream_id = "web_notification_channel:#{arguments.first}"
    ActionCable.server.broadcast(stream_id, message: message, card: card)
  end
end

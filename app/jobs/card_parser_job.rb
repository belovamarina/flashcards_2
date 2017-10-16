class CardParserJob < ApplicationJob
  queue_as :default
  rescue_from(StandardError) do |error|
    logger.error "There was an issue: #{error.class}\n#{error.message}"
  end

  def perform(current_user, url:, original_xpath:, translated_xpath:, block_id:)
    html = load_page(url)
    words = parse_page(html, original_xpath, translated_xpath)
    current_user.cards.create(build_cards(block_id, words))
  end

  private

  def load_page(url)
    Nokogiri::HTML(open(url))
  end

  def parse_page(html, original_xpath, translated_xpath)
    original_words = html.xpath(original_xpath).map { |word| word.text.strip }
    translated_words = html.xpath(translated_xpath).map { |word| word.text.strip }
    original_words.zip(translated_words).reject { |pair| pair.compact.size != 2 }
  end

  def build_cards(block_id, words)
    words.map do |word|
      { original_text: word.first, translated_text: word.last, block_id: block_id }
    end
  end
end

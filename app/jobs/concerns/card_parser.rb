class CardParser
  attr_reader :body, :error

  def initialize(url, original_xpath, translated_xpath)
    @url = url
    @original_xpath = original_xpath
    @translated_xpath = translated_xpath
  end

  def parse
    load_page
    parse_page
  rescue => e
    @error = e.message
  end

  private

  def load_page
    @body = Nokogiri::HTML(open(@url))
  end

  def parse_page
    original_words = body.xpath(@original_xpath).map { |word| word.text.strip }
    translated_words = body.xpath(@translated_xpath).map { |word| word.text.strip }
    original_words.zip(translated_words).reject { |pair| pair.compact.size != 2 }
  end
end

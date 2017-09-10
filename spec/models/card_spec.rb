require 'rails_helper'

describe Card do
  context 'create non-valid card' do
    it 'create card with empty original text' do
      card = build(:card, original_text: '')
      card.valid?
      expect(card.errors[:original_text]).to include('Необходимо заполнить поле.')
    end

    it 'create card with empty translated text' do
      card = build(:card, translated_text: '')
      card.valid?
      expect(card.errors[:translated_text])
        .to include('Необходимо заполнить поле.')
    end

    it 'create card with empty texts' do
      card = build(:card, original_text: '', translated_text: '')
      card.valid?
      expect(card.errors[:original_text])
        .to include('Вводимые значения должны отличаться.')
    end

    it 'equal_texts Eng' do
      card = build(:card, original_text: 'house', translated_text: 'house')
      card.valid?
      expect(card.errors[:original_text])
        .to include('Вводимые значения должны отличаться.')
    end

    it 'equal_texts Rus' do
      card = build(:card, original_text: 'дом', translated_text: 'дом')
      card.valid?
      expect(card.errors[:original_text])
        .to include('Вводимые значения должны отличаться.')
    end

    it 'full_downcase Eng' do
      card = build(:card, original_text: 'hOuse', translated_text: 'houSe')
      card.valid?
      expect(card.errors[:original_text])
        .to include('Вводимые значения должны отличаться.')
    end

    it 'full_downcase Rus' do
      card = build(:card, original_text: 'Дом', translated_text: 'доМ')
      card.valid?
      expect(card.errors[:original_text])
        .to include('Вводимые значения должны отличаться.')
    end

    it 'create card witout user_id' do
      card = build(:card, user_id: nil)
      card.valid?
      expect(card.errors[:user_id])
        .to include('Ошибка ассоциации.')
    end

    it 'create card witout block_id' do
      card = build(:card, block_id: nil)
      card.valid?
      expect(card.errors[:block_id])
        .to include('Выберите колоду из выпадающего списка.')
    end
  end

  context 'create valid card' do
    let(:card) { create(:card) }

    it 'create card original_text OK' do
      expect(card.original_text).to eq('дом')
    end

    it 'create card translated_text OK' do
      expect(card.translated_text).to eq('house')
    end

    it 'create card errors OK' do
      expect(card.errors.any?).to be false
    end

    it 'set_review_date OK' do
      expect(card.review_date.strftime('%Y-%m-%d %H:%M'))
        .to eq(Time.zone.now.strftime('%Y-%m-%d %H:%M'))
    end
  end

  describe '#check_translation' do
    context 'success card review' do
      let(:card) { create(:card) }
      let(:card_ru) { create(:card, original_text: 'house', translated_text: 'дом') }

      it 'check_translation Eng OK' do
        check_result = card.check_translation('house')
        expect(check_result[:state]).to be true
      end

      it 'check_translation full_downcase Eng OK' do
        check_result = card.check_translation('HousE')
        expect(check_result[:state]).to be true
      end

      it 'check_translation Eng OK levenshtein_distance' do
        check_result = card.check_translation('housee')
        expect(check_result[:state]).to be true
      end

      it 'check_translation Eng OK levenshtein_distance=1' do
        check_result = card.check_translation('hous')
        expect(check_result[:distance]).to be 1
      end

      it 'check_translation Rus OK' do
        check_result = card_ru.check_translation('дом')
        expect(check_result[:state]).to be true
      end

      it 'check_translation full_downcase Rus OK' do
        check_result = card_ru.check_translation('дОм')
        expect(check_result[:state]).to be true
      end

      it 'check_translation Rus OK levenshtein_distance' do
        check_result = card_ru.check_translation('до')
        expect(check_result[:state]).to be true
      end

      it 'check_translation Rus OK levenshtein_distance=1' do
        check_result = card_ru.check_translation('домм')
        expect(check_result[:distance]).to be 1
      end
    end

    context 'fail card review' do
      let(:card) { create(:card) }
      let(:card_ru) { create(:card, original_text: 'house', translated_text: 'дом') }

      it 'check_translation Eng NOT' do
        check_result = card.check_translation('RoR')
        expect(check_result[:state]).to be false
      end

      it 'check_translation full_downcase Eng NOT' do
        check_result = card.check_translation('RoR')
        expect(check_result[:state]).to be false
      end

      it 'check_translation Eng NOT levenshtein_distance=2' do
        check_result = card_ru.check_translation('RoR')
        expect(check_result[:state]).to be false
      end

      it 'check_translation Rus NOT' do
        check_result = card_ru.check_translation('RoR')
        expect(check_result[:state]).to be false
      end

      it 'check_translation full_downcase Rus NOT' do
        check_result = card_ru.check_translation('ROR')
        expect(check_result[:state]).to be false
      end

      it 'check_translation Rus NOT levenshtein_distance=2' do
        check_result = card_ru.check_translation('RoRor')
        expect(check_result[:state]).to be false
      end
    end
  end
end

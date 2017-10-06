require 'rails_helper'

describe 'API flashcards', type: :request do
  let(:user) { create(:user_with_one_block_and_one_card) }

  context 'requests with success authentication' do
    before do
      basic_auth(user.email, '12345')
    end

    it 'GET main#index' do
      get '/api', headers: @env
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Welcome!')
    end

    it 'GET #cards/index' do
      get '/api/v1/cards', headers: @env
      json = JSON.parse(response.body).first
      expect(json.keys).to include('id', 'original_text', 'translated_text', 'block_id')
    end

    it 'POST #cards/index' do
      cards_params = { card: { original_text: 'train', translated_text: 'поезд', block_id: user.blocks.first.id }}
      post '/api/v1/cards', headers: @env, params: cards_params
      expect(response.status).to eq(201)
    end

    it 'GET #trainer' do
      get '/api/v1/trainer', headers: @env
      json = JSON.parse(response.body)
      expect(json.keys).to include('id', 'original_text', 'translated_text', 'block_id')
    end

    it 'PUT #review_card' do
      trainer_params = { user_translation: 'house', card_id: user.cards.first.id }
      put '/api/v1/review_card', headers: @env, params: trainer_params
      json = JSON.parse(response.body)
      expect(json).to have_key('state')
    end
  end

  context 'requests with fail authentication' do
    before do
      basic_auth(user.email, '123456')
    end

    it 'GET main#index' do
      get '/api', headers: @env
      expect(response.status).to eq(401)
    end

    it 'GET #cards/index' do
      get '/api/v1/cards', headers: @env
      expect(response.status).to eq(401)
    end

    it 'POST #cards/index' do
      cards_params = { card: { original_text: 'train', translated_text: 'поезд', block_id: user.blocks.first.id }}
      post '/api/v1/cards', headers: @env, params: cards_params
      expect(response.status).to eq(401)
    end
  end
end

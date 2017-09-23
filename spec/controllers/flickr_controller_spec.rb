require 'rails_helper'

describe Dashboard::FlickrController do
  before(:each) do
    user = create(:user)
    @controller.send(:auto_login, user)
    stub_request(:get, /api\.flickr\.com/).to_return(body: "{\"photos\":{\"photo\":[]},\"stat\":\"ok\"}", status: 200)
  end

  it 'search photos' do
    post :search_photos, params: {flickr: { text: "Cat" }}
    expect(response.status).to eq(200)
  end
end

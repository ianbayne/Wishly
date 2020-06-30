require 'rails_helper'

RSpec.describe 'Wishlists', type: :request do
  let(:owner)         { User.new(email: 'owner@example.com') }
  let(:wishlist_item) { WishlistItem.new(name: 'item 1') }

  describe 'GET /new' do
    it 'returns http success' do
      get '/wishlists/new'

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'returns http success' do
      post '/wishlists', params: {
        wishlist: {
          title: 'Example title',
          owner: owner,
          wishlist_item: wishlist_item
        }
      }

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      wishlist = Wishlist.create!(title: 'Example wishlist', owner: owner)
      get "/wishlists/#{wishlist.id}"

      expect(response).to have_http_status(:success)
    end
  end
end

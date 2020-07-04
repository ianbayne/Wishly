require 'rails_helper'

RSpec.describe 'Wishlists', type: :request do
  let(:wishlist_params) do
    {
      wishlist: {
        title: 'Example title',
        owner_attributes: { email: 'owner@example' },
        wishlist_items_attributes: {
          '0' => { name: 'item 1' }
        },
        invitees_attributes: {
          '0' => { email: 'invitee@example.com' }
        }
      }
    }
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/wishlists/new'

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'returns http redirect' do
      post '/wishlists', params: wishlist_params

      expect(response).to have_http_status(:redirect)
    end

    it 'creates a wishlist' do
      expect do
        post '/wishlists', params: wishlist_params
      end.to change { Wishlist.count }.by(1)
    end

    it 'sends emails to the wishlist owner and each invitee' do
      expect do
        post '/wishlists', params: wishlist_params
      end.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end

  describe 'GET /show' do
    let(:wishlist) do
      Wishlist.create!(
        title: 'Example wishlist',
        owner: User.new(email: 'owner@example.com'),
        wishlist_items: [
          WishlistItem.new(name: 'Item 1')
        ],
        invitees: [
          User.new(email: 'invitee@example.com')
        ]
      )
    end

    it 'returns http success with a valid user id' do
      get "/wishlists/#{wishlist.id}?user_id=#{wishlist.owner.id}"

      expect(response).to have_http_status(:success)
    end

    it 'redirects to the root page without a valid user id' do
      get "/wishlists/#{wishlist.id}"

      expect(response).to redirect_to(root_url)
    end
  end
end

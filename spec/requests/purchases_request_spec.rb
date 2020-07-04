require 'rails_helper'

RSpec.describe 'Purchases', type: :request do
  let(:owner)         { User.create!(email: 'owner@example.com') }
  let(:invitee)       { User.create(email: 'invitee@example.com') }
  let(:wishlist_item) { WishlistItem.new(name: 'Item') }
  let(:wishlist) do
    Wishlist.create!(
      title:          'Example title',
      owner:          owner,
      invitees:       [invitee],
      wishlist_items: [wishlist_item]
    )
  end

  describe 'POST /create' do
    it 'returns http success' do
      post "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
        xhr: true, params: { user_id: invitee.id }

      expect(response).to have_http_status(:success)
    end

    it 'creates a purchase for the wishlist item' do
      expect do
        post "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
          xhr: true, params: { user_id: invitee.id }
      end.to change { Purchase.count }.by(1)
    end
  end

  describe 'POST /destroy' do
    before do
      post "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
        xhr: true, params: { user_id: invitee.id }
    end

    it 'returns http success' do
      delete "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
          xhr: true, params: { user_id: invitee.id }
      expect(response).to have_http_status(:success)
    end

    it "destroys the wishlist item's purchase" do
      expect do
        delete "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
          xhr: true, params: { user_id: invitee.id }
      end.to change { Purchase.count }.by(-1)
    end
  end

end

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

    context 'when the user is the owner of the wishlist' do
      it 'does not create a purchase for the wishlist item' do
        expect do
          post "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
            xhr: true, params: { user_id: owner.id }
        end.to change { Purchase.count }.by(0)
      end
    end

    context 'when the user is an invitee of the wishlist' do
      it 'creates a purchase for the wishlist item' do
        expect do
          post "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
            xhr: true, params: { user_id: invitee.id }
        end.to change { Purchase.count }.by(1)
      end
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

    context 'when the purchase was created by the user' do
      it "destroys the wishlist item's purchase" do
        expect do
          delete "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
            xhr: true, params: { user_id: invitee.id }
        end.to change { Purchase.count }.by(-1)
      end
    end

    context 'when the purchase was not created by the user' do
      let(:non_purchaser) { User.create!(email: 'non_purchaser@example.com') }

      it "does not destroy the wishlist item's purchase" do
        expect do
          delete "/wishlists/#{wishlist.id}/wishlist_items/#{wishlist_item.id}",
            xhr: true, params: { user_id: non_purchaser.id }
        end.to change { Purchase.count }.by(0)
      end
    end
  end

end

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
      end.to(
        enqueue_job(ActionMailer::MailDeliveryJob)
          .exactly(2)
          .times
      )

      wishlist_params_with_another_invitee = wishlist_params.deep_merge!(
        wishlist: {
          invitees_attributes: {
            '1' => { email: 'invitee_2@example.com' }
          }
        }
      )

      expect do
        post '/wishlists', params: wishlist_params_with_another_invitee
      end.to(
        enqueue_job(ActionMailer::MailDeliveryJob)
          .exactly(3)
          .times
      )
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

    it "returns http success with the owner's user id" do
      get "/wishlists/#{wishlist.id}?user_id=#{wishlist.owner.id}"

      expect(response).to have_http_status(:success)
    end

    it "returns http success with an invitee's user id" do
      get "/wishlists/#{wishlist.id}?user_id=#{wishlist.invitees.first.id}"

      expect(response).to have_http_status(:success)
    end

    it 'redirects to the root page without a valid user id' do
      get "/wishlists/#{wishlist.id}"

      expect(response).to redirect_to(root_url)
    end

    it 'redirects to the root page with a user id for which the user is not ' \
       'the wishlist owner or an invitee' do
      invalid_user = User.create!(email: 'invalid@example.com')

      get "/wishlists/#{wishlist.id}?user_id=#{invalid_user.id}"

      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET /edit' do
    xit 'navigates to the edit screen'
  end

  describe 'PUT /update' do
    xit 'updates the wishlist'
  end
end

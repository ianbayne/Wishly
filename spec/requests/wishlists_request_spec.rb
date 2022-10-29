require 'rails_helper'

RSpec.describe 'Wishlists', type: :request do
  let(:wishlist_params) do
    {
      wishlist: {
        title: 'Example title',
        owner_attributes: { email: 'owner@example.com' },
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
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    it 'returns http redirect ' do
      post '/wishlists', params: wishlist_params

      expect(response).to redirect_to("/wishlists/#{Wishlist.last.id}?user_id=#{Wishlist.last.owner.id}")
      expect(flash[:notice]).to match(/Wishlist created/)
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
      expect(response).to render_template(:show)
    end

    it "returns http success with an invitee's user id" do
      get "/wishlists/#{wishlist.id}?user_id=#{wishlist.invitees.first.id}"

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    it 'redirects to the root page without a valid user id' do
      get "/wishlists/#{wishlist.id}"

      expect(response).to redirect_to('/')
      expect(flash[:alert]).to match(
        /The wishlist you are trying to access does not exist or you do not have access to it/
      )
    end

    it 'redirects to the root page with a user id for which the user is not ' \
       'the wishlist owner or an invitee' do
      invalid_user = User.create!(email: 'invalid@example.com')

      get "/wishlists/#{wishlist.id}?user_id=#{invalid_user.id}"

      expect(response).to redirect_to('/')
      expect(flash[:alert]).to match(
        /The wishlist you are trying to access does not exist or you do not have access to it/
      )
    end
  end

  describe 'GET /edit' do
    let(:owner) { User.create!(email: 'owner@example.com') }
    let(:invitee) { User.create!(email: 'invitee@example.com') }
    let(:wishlist) do
      Wishlist.create!(
        title: 'Example wishlist',
        owner: owner,
        wishlist_items: [
          WishlistItem.new(name: 'Item 1')
        ],
        invitees: [
          invitee
        ]
      )
    end
    # http://localhost:3000/wishlists/54a02490-891d-499e-876d-09e1b0224559/edit?user_id=79f0de87-58e8-42c9-aab0-e749a820769d

    it 'navigates to the edit screen with correct wishlist id and owner id' do
      get "/wishlists/#{wishlist.id}/edit?user_id=#{owner.id}"

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'redirects to the root page without a valid user id' do
      get "/wishlists/#{wishlist.id}/edit"

      expect(response).to redirect_to('/')
      expect(flash[:alert]).to match(
        /The wishlist you are trying to access does not exist or you do not have access to it/
      )
    end

    it 'redirects to the root page when user id is not owner id' do
      get "/wishlists/#{wishlist.id}/edit?user_id=#{invitee.id}"

      expect(response).to redirect_to('/')
      expect(flash[:alert]).to match(
        /The wishlist you are trying to access does not exist or you do not have access to it/
      )
    end
  end

  describe 'PUT /update' do
    xit 'updates the wishlist'
  end
end

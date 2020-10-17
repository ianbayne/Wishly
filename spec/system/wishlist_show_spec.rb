require 'rails_helper'

RSpec.describe "WishlistShow", type: :system do
  let(:wishlist) do
    Wishlist.create!(
      title:    'Example title',
      owner:    User.new(email: 'owner@example.com'),
      invitees: [
        User.new(email: 'invitee_1@example.com'),
        User.new(email: 'invitee_2@example.com')
      ],
      wishlist_items: [
        WishlistItem.new(name: 'Item')
      ]
    )
  end

  before do
    driven_by(:rack_test)
  end

  context "when the wishlist's owner" do
    it 'cannot see the purchase button' do
      visit "/wishlists/#{wishlist.id}?user_id=#{wishlist.owner.id}"

      expect(page).not_to have_text('Purchase')
    end
  end

  context "when one of the wishlist's invitees" do
    it 'can see the purchase button' do
      visit "/wishlists/#{wishlist.id}?user_id=#{wishlist.invitees.first.id}"

      expect(page).to have_link('Purchase')
    end
  end

  context "when one invitee has purchased an item" do
    it 'can see the cancel purchase button when the purchaser' do
      purchaser = wishlist.invitees.first

      Purchase.create!(
        wishlist_item: wishlist.wishlist_items.first,
        user:          purchaser
      )

      visit "/wishlists/#{wishlist.id}?user_id=#{purchaser.id}"

      expect(page).to have_link('Cancel purchase')
    end

    it 'cannot see the cancel purchase or purchase button when not the ' \
       'purchaser' do
      purchaser     = wishlist.invitees.first
      non_purchaser = wishlist.invitees.second

      purchase = Purchase.create!(
        wishlist_item: wishlist.wishlist_items.first,
        user:          purchaser
      )

      visit "/wishlists/#{wishlist.id}?user_id=#{non_purchaser.id}"

      aggregate_failures do
        expect(page).not_to have_link('Cancel purchase')
        expect(page).not_to have_link('Purchase')
        expect(page).to(have_text(
          "Purchased by #{purchaser.email} on " \
          "#{purchase.created_at.strftime('%A, %B %e')}")
        )
      end
    end
  end

end

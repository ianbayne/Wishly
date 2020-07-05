require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  let(:wishlist)      { Wishlist.new }
  let(:user)          { User.new(email: 'owner@example.com') }
  let(:wishlist_item) { WishlistItem.new(name: 'Item') }
  let(:invitee)       { User.new(email: 'invitee@example.com') }

  it 'is valid with a title, an owner, an item, and an invitee' do
    wishlist.title = 'New wishlist'
    wishlist.owner = user
    wishlist.wishlist_items << wishlist_item
    wishlist.invitees << invitee
    wishlist.save

    expect(wishlist).to be_valid
  end

  it 'is invalid without a title' do
    wishlist.owner = user
    wishlist.wishlist_items << wishlist_item
    wishlist.invitees << invitee
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  it 'is invalid without a user' do
    wishlist.title = 'New wishlist'
    wishlist.wishlist_items << wishlist_item
    wishlist.invitees << invitee
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  it 'is invalid without at least one wishlist item' do
    wishlist.title = 'New wishlist'
    wishlist.owner = user
    wishlist.invitees << invitee
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  it 'is invalid without at least one invitee' do
    wishlist.title = 'New wishlist'
    wishlist.owner = user
    wishlist.wishlist_items << wishlist_item
    wishlist.save

    expect(wishlist).not_to be_valid
  end
end

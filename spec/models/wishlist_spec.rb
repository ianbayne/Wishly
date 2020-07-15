require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  let(:wishlist)      { Wishlist.new }
  let(:user)          { User.new(email: 'owner@example.com') }
  let(:item) { WishlistItem.new(name: 'Item') }
  let(:invitee)       { User.new(email: 'invitee@example.com') }

  it 'is valid with a title, an owner, an item, and an invitee' do
    wishlist.title = 'New wishlist'
    wishlist.owner = user
    wishlist.wishlist_items << item
    wishlist.invitees << invitee
    wishlist.save

    expect(wishlist).to be_valid
  end

  it 'is invalid without a title' do
    wishlist.owner = user
    wishlist.wishlist_items << item
    wishlist.invitees << invitee
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  it 'is invalid without a user' do
    wishlist.title = 'New wishlist'
    wishlist.wishlist_items << item
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
    wishlist.wishlist_items << item
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  context 'when two participants use a gmail addresses' do
    let(:gmail_user_without_period) do
      User.new(email: 'examplename@gmail.com')
    end
    let(:gmail_user_with_period) do
      User.new(email: 'example.name@gmail.com')
    end

    it 'cannot have addresses that would be duplicates without periods' do
      wishlist = Wishlist.new(
        title:          'Example wishlist',
        owner:          gmail_user_without_period,
        invitees:       [gmail_user_with_period],
        wishlist_items: [item]
      )
      wishlist.save

      aggregate_failures do
        expect(wishlist).not_to be_valid
        expect(wishlist.errors.full_messages).to(
          include 'Wishlist email addresses must be unique.'
        )
      end
    end
  end
end

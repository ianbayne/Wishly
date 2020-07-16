require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  let(:wishlist) { Wishlist.new }
  let(:user)     { User.new(email: 'owner@example.com') }
  let(:item)     { WishlistItem.new(name: 'Item') }
  let(:invitee)  { User.new(email: 'invitee@example.com') }

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

  it 'is invalid without an owner' do
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

  context 'when two participants have emails with periods or plus signs' do
    context "when they're gmail addresses" do
      let(:gmail_user_without_period) do
        User.new(email: 'examplename@gmail.com')
      end
      let(:gmail_user_with_period) do
        User.new(email: 'example.name@gmail.com')
      end
      let(:gmail_user_without_plus_sign) do
        User.new(email: 'example@gmail.com')
      end
      let(:gmail_user_with_plus_sign) do
        User.new(email: 'example+name@gmail.com')
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

      it 'cannot have addresses that would be duplicates if the plus sign ' \
         'and everything after were removed' do
        wishlist = Wishlist.new(
          title:          'Example wishlist',
          owner:          gmail_user_without_plus_sign,
          invitees:       [gmail_user_with_plus_sign],
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

    context "when they're not gmail addresses" do
      let(:non_gmail_user_without_period) do
        User.new(email: 'examplename@hotmail.com')
      end
      let(:non_gmail_user_with_period) do
        User.new(email: 'example.name@hotmail.com')
      end
      let(:non_gmail_user_without_plus_sign) do
        User.new(email: 'example@hotmail.com')
      end
      let(:non_gmail_user_with_plus_sign) do
        User.new(email: 'example+name@hotmail.com')
      end

      it 'can have addresses that would be duplicates without periods' do
        wishlist = Wishlist.new(
          title:          'Example wishlist',
          owner:          non_gmail_user_without_period,
          invitees:       [non_gmail_user_with_period],
          wishlist_items: [item]
        )
        wishlist.save

        expect(wishlist).to be_valid
      end

      it 'can have addresses that would be duplicates if the plus sign ' \
         'and everything after were removed' do
        wishlist = Wishlist.new(
          title:          'Example wishlist',
          owner:          non_gmail_user_without_plus_sign,
          invitees:       [non_gmail_user_with_plus_sign],
          wishlist_items: [item]
        )
        wishlist.save

        expect(wishlist).to be_valid
      end
    end
  end
end

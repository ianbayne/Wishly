require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  let(:wishlist) { Wishlist.new }
  let(:user)     { User.new(email: 'owner@example.com') }
  let(:item)     { WishlistItem.new(name: 'Item') }
  let(:invitee)  { User.new(email: 'invitee@example.com') }

  describe 'associations' do
    it { should belong_to(:owner).class_name('User').dependent(:destroy) }
    it { should have_many(:wishlist_items).dependent(:destroy) }
    it { should have_many(:wishlist_invitees).dependent(:destroy) }
    it { should have_many(:invitees) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:invitees) }
    it { should validate_presence_of(:wishlist_items) }
  end

  it 'has participants with case insensitively unique email addresses' do
    wishlist.title    = 'New wishlist'
    wishlist.owner    = User.new(email: 'EXAMPLE@email.com')
    wishlist.invitees << User.new(email: 'example@email.com')
    wishlist.wishlist_items << item
    wishlist.save

    aggregate_failures do
      expect(wishlist).not_to be_valid
      expect(wishlist.errors.full_messages).to(
        include 'Wishlist email addresses must be unique.'
      )
    end
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

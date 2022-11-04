require 'rails_helper'

RSpec.describe WishlistItem, type: :model do
  describe 'associations' do
    it { should belong_to(:wishlist) }
    it { should have_one(:purchase).dependent(:destroy) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '.add_url_protocol' do
    it 'should add url protocol before saving' do
      wishlist = Wishlist.create!(
        title: 'Example wishlist',
        owner: User.new(email: 'owner@example.com'),
        invitees: [User.new(email: 'invitee@example.com')],
        wishlist_items: [WishlistItem.new(name: 'Example item')]
      )

      wishlist_item = WishlistItem.new(
        name: 'New bike', 
        url: 'www.example.com',
        wishlist: wishlist
      )
      wishlist_item.save!

      expect(wishlist_item.url).to eq 'https://www.example.com'
    end
  end
end


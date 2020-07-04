require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  let(:wishlist) { Wishlist.new }
  let(:user)     { User.new(email: 'user@example.com') }

  it 'is valid with a title and an owner' do
    wishlist.title = 'New wishlist'
    wishlist.owner = user
    wishlist.save

    expect(wishlist).to be_valid
  end

  it 'is invalid without a title' do
    wishlist.owner = user
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  it 'is invalid without a user' do
    wishlist.title = 'New wishlist'
    wishlist.save

    expect(wishlist).not_to be_valid
  end
end

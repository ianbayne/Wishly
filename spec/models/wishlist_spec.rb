require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  let(:wishlist) { Wishlist.new }
  let(:user)     { User.new }

  it 'is valid with a title and a user' do
    wishlist.title = 'New wishlist'
    wishlist.user  = user
    wishlist.save

    expect(wishlist).to be_valid
  end

  it 'is invalid without a title' do
    wishlist.user = user
    wishlist.save

    expect(wishlist).not_to be_valid
  end

  it 'is invalid without a user' do
    wishlist.title = 'New wishlist'
    wishlist.save

    expect(wishlist).not_to be_valid
  end
end

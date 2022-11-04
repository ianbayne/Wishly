require 'rails_helper'

RSpec.describe WishlistInvitee, type: :model do
  describe 'associations' do
    it { should belong_to(:user).dependent(:destroy) }
    it { should belong_to(:wishlist) }
  end
end

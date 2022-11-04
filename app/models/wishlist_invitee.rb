class WishlistInvitee < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :wishlist
end

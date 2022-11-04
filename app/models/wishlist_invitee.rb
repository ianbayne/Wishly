class WishlistInvitee < ApplicationRecord
  belongs_to :user, dependent: :destroy # Required to ensure an invitee is destroyed when their wishlist is
  belongs_to :wishlist
end

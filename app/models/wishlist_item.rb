class WishlistItem < ApplicationRecord
  belongs_to :wishlist

  validates :name, presence: true
end

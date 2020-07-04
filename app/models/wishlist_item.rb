class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  has_one :purchase

  validates :name, presence: true

  def purchased?
    !!purchase
  end
end

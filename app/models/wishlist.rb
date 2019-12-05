class Wishlist < ApplicationRecord
  belongs_to :user, touch: true
  has_many :wishlist_items
end

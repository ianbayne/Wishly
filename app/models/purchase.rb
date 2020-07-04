class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :wishlist_item
end

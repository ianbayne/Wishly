class WishlistItem < ApplicationRecord
  belongs_to :wishlist,
             touch: true,
             inverse_of: :wishlist_items
  belongs_to :purchased_by,
             foreign_key: 'purchased_by_id',
             class_name:  'User',
             optional:    true

  validates :name, presence: true
end

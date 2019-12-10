class Wishlist < ApplicationRecord
  belongs_to :user, touch: true
  has_many :wishlist_items, dependent: :destroy

  validates :title, presence: true
end

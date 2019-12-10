class Wishlist < ApplicationRecord
  belongs_to :user, touch: true
  has_many :wishlist_items, dependent: :destroy

  accepts_nested_attributes_for :wishlist_items

  validates :title, presence: true
end

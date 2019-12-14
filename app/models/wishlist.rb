class Wishlist < ApplicationRecord
  belongs_to :user, touch: true
  has_many :wishlist_items,
           -> { order(created_at: :asc) },
           inverse_of: :wishlist,
           dependent: :destroy
  accepts_nested_attributes_for :wishlist_items,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :title, presence: true
end

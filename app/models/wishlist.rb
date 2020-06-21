class Wishlist < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many   :wishlist_items
  has_many   :wishlist_invitees
  has_many   :invitees, through: :wishlist_invitees, source: :user

  validates :title, presence: true
end

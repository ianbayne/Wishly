class User < ApplicationRecord
  has_one :wishlist, dependent: :destroy

  validates :email, presence: true
end

class CreateWishlistForm
  include ActiveModel::Model

  attr_accessor :title
  attr_accessor :name
  attr_accessor :current_user

  validates :title, presence: true
  validates :name, presence: true

  def save
    return false unless valid?
    wishlist = Wishlist.create(title: title, user: current_user)
    wishlist.wishlist_items.create(name: name)
  end
end
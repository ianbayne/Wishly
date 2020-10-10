class AddUrlToWishlistItems < ActiveRecord::Migration[6.0]
  def change
    add_column :wishlist_items, :url, :text, null: true
  end
end

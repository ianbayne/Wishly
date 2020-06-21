class CreateWishlistItems < ActiveRecord::Migration[6.0]
  def change
    create_table :wishlist_items do |t|
      t.string :name
      t.references :wishlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end

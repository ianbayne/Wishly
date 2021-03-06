class CreateWishlistInvitees < ActiveRecord::Migration[6.0]
  def change
    create_table :wishlist_invitees do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :wishlist, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end

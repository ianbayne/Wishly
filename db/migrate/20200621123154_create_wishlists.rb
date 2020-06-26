class CreateWishlists < ActiveRecord::Migration[6.0]
  def change
    create_table :wishlists, id: :uuid do |t|
      t.string :title
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end

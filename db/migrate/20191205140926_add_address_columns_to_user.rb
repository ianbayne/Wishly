class AddAddressColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
  end
end

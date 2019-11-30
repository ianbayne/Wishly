class AddPhoneNumberToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone_data, :json, default: {}
  end
end

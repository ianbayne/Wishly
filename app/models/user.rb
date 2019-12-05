class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :wishlist

  def phone_number
    PhoneNumber.new(
      phone_data['country_code'],
      phone_data['area_code'],
      phone_data['number']
    )
  end

  def address
    Address.new(address_city, address_state)
  end

  def address=(address)
    self.address_city  = address.city
    self.address_state = address.state
  end
end

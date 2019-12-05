# Value object for user addresses

class Address
  attr_reader :city, :state

  def initialize(city, state)
    @city  = city
    @state = state
  end

  def to_s
    "#{city}, #{state}"
  end

  def ==(other_address)
    city == other_address.city && state == other_address.state
  end
end

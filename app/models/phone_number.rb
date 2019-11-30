# Value object for user phone numbers

class PhoneNumber
  attr_reader :country_code, :area_code, :number

  def initialize(country_code, area_code, number)
    @country_code = country_code
    @area_code    = area_code
    @number       = number
  end

  def full_number
    "+#{country_code} #{area_code} #{number}"
  end
end

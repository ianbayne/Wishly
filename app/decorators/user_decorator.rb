class UserDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
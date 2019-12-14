# Set up Ian
ian = User.create!(
  first_name: 'Ian',
  last_name:  'Bayne',
  email:      'ian@example.com',
  password:   'password'
)

ian.create_wishlist!(title: "Ian's Christmas Wishlist")

5.times do |i|
  ian.wishlist.wishlist_items.create!(name: "Item ##{i}")
end

# Set up Holly

holly = User.create!(
  first_name: 'Holly',
  last_name:  'Bayne',
  email:      'holly@example.com',
  password:   'password'
)

holly.create_wishlist!(title: "Holly's Birthday list")

5.times do |i|
  holly.wishlist.wishlist_items.create!(name: "Item ##{i}")
end

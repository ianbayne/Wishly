puts 'Starting seeding...'

# Set up Ian
ian = User.find_or_create_by!(email: 'ian@example.com') do |user|
  user.first_name = 'Ian'
  user.last_name  = 'Bayne'
  user.password   = 'password'
end

ian.create_wishlist(title: "Ian's Christmas Wishlist")

(1..5).each.with_index(1) do |i|
  ian.wishlist.wishlist_items.create(name: "Item ##{i}")
  print '.'
end

# Set up Holly
holly = User.find_or_create_by!(email: 'holly@example.com') do |user|
  user.first_name = 'Holly'
  user.last_name  = 'Bayne'
  user.password   = 'password'
end

holly.create_wishlist(title: "Holly's Birthday list")

(1..5).each.with_index(1) do |i|
  holly.wishlist.wishlist_items.create(name: "Item ##{i}")
  print '.'
end

puts "\nFinished seeding! #{User.count} users created with wishlists."
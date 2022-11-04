# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

wishlist = Wishlist.new(title: 'Example wishlist')
wishlist.build_owner(email: 'owner@example.com')
wishlist.wishlist_items.build([{name: 'New bike', url: 'www.example.com'}])
wishlist.invitees.build([{email: 'invitee@example.com'}])
wishlist.wishlist_items.first.build_purchase(user: wishlist.invitees.first)
wishlist.save!

num_of_wishlists = Wishlist.count
smart_pluralization = num_of_wishlists == 1 ? nil : 's'
puts "Database seeded! Now #{num_of_wishlists} wishlist#{smart_pluralization} in the database"
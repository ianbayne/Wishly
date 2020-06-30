# Preview all emails at http://localhost:3000/rails/mailers/wishlist_mailer
class WishlistMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/wishlist_mailer/new_wishlist_created
  def new_wishlist_created
    owner    = User.create!(email: 'owner@example.com')
    wishlist = Wishlist.create!(title: 'Example wishlist', owner: owner)

    WishlistMailer.with(wishlist: wishlist, recipient: owner).new_wishlist_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/wishlist_mailer/invited_to_wishlist
  def invited_to_wishlist
    owner    = User.create!(email: 'owner@example.com')
    wishlist = Wishlist.create!(title: 'Example wishlist', owner: owner)
    invitee  = User.create!(email: 'invitee@example.com')

    WishlistMailer.with(wishlist: wishlist, recipient: invitee).invited_to_wishlist
  end

end

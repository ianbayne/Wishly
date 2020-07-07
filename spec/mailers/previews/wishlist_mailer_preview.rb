# Preview all emails at http://localhost:3000/rails/mailers/wishlist_mailer
class WishlistMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/wishlist_mailer/new_wishlist_created
  def new_wishlist_created
    wishlist = Wishlist.create!(
      title:          'Example wishlist',
      owner:          User.new(email: 'owner@example.com'),
      wishlist_items: [WishlistItem.new(name: 'Item')],
      invitees:       [User.new(email: 'invitee@example.com')]
    )

    WishlistMailer.with(wishlist_id: wishlist.id, recipient_id: wishlist.owner.id)
                  .new_wishlist_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/wishlist_mailer/invited_to_wishlist
  def invited_to_wishlist
    wishlist = Wishlist.create!(
      title:          'Example wishlist',
      owner:          User.new(email: 'owner@example.com'),
      wishlist_items: [WishlistItem.new(name: 'Item')],
      invitees:       [User.new(email: 'invitee@example.com')]
    )

    WishlistMailer.with(wishlist_id: wishlist.id, recipient_id: wishlist.invitees.first.id)
                  .invited_to_wishlist
  end

end

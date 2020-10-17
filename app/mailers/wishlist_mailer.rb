class WishlistMailer < ApplicationMailer
  before_action do
    @wishlist  = Wishlist.find(params[:wishlist_id])
    @recipient = User.find(params[:recipient_id])
  end

  default to: -> { @recipient.email }

  def new_wishlist_created
    mail subject: 'You created a new wishlist!'
  end

  def invited_to_wishlist
    mail subject: 'Someone invited you to their wishlist!'
  end

  def wishlist_updated
    mail subject: "#{@wishlist.owner.email} updated their wishlist!"
  end
end

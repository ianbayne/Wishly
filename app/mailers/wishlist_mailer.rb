class WishlistMailer < ApplicationMailer
  before_action { @wishlist, @recipient = params[:wishlist], params[:recipient] }

  default to: -> { @recipient.email }

  def new_wishlist_created
    mail subject: 'You created a new wishlist!'
  end

  def invited_to_wishlist
    mail subject: 'Someone invited you to their wishlist!'
  end
end

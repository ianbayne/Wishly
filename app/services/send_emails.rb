# frozen_string_literal: true

class SendEmails # rubocop:disable Style/Documentation
  def initialize(owner:, invitees:)
    @owner = owner
    @invitees = invitees
  end

  def call
    if @owner
      WishlistMailer.with(wishlist_id: @owner.wishlist.id, recipient_id: @owner.id)
                    .new_wishlist_created.deliver_later
    end

    @invitees&.each do |invitee|
      WishlistMailer.with(wishlist_id: @owner.wishlist.id, recipient_id: invitee.id)
                    .invited_to_wishlist.deliver_later
    end
  end
end

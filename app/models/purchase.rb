# frozen_string_literal: true

class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :wishlist_item

  after_create_commit lambda {
    broadcast_replace_later_to 'purchase',
                               partial: 'wishlists/purchased_item',
                               locals: {
                                 wishlist_item:,
                                 wishlist: wishlist_item.wishlist,
                                 # TODO: Broadcasts as if the current user is the one who purchased it
                                 user: Current.user,
                                 purchased_by_current_user: Current.user == user
                               },
                               target: "wishlist_item_#{wishlist_item.id}"
  }
  after_destroy_commit lambda {
    broadcast_replace_later_to 'purchase',
                               partial: 'wishlists/unpurchased_item',
                               locals: {
                                 wishlist_item:,
                                 wishlist: wishlist_item.wishlist,
                                 # TODO: Broadcasts as if the current user is the one who cancelled the purchased
                                 user: Current.user
                               },
                               target: "wishlist_item_#{wishlist_item.id}"
  }
end

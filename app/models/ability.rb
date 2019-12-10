# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Wishlist
    can :manage, Wishlist, user_id: user.id
    # TODO: Fix
    # can :manage, WishlistItem, wishlist_id: user.wishlist.id
    can :manage, WishlistItem, :all
    # TODO: Fix
    can :manage, CreateWishlistForm, :all
  end
end

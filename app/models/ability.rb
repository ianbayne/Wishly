# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Wishlist
    can :manage, Wishlist, user_id: user.id
    can :manage, WishlistItem, wishlist_id: user.wishlist.id
  end
end

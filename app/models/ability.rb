# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Wishlist
    can :edit, Wishlist, user_id: user.id
  end
end

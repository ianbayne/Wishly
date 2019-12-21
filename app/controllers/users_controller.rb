class UsersController < ApplicationController
  def index
    users = User.all.includes(:wishlist)
    @decorated_users = UserDecorator.wrap(users)
  end
end

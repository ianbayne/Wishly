class UsersController < ApplicationController
  def index
    users = User.all
    @decorated_users = UserDecorator.wrap(users)
  end
end

class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def show
    @wishlist = Wishlist.find_by(id: params[:id])

    if @wishlist.nil?
      redirect_back fallback_location: root_path,
                    alert: "We couldn't find that wishlist."
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

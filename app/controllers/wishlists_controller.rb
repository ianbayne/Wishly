class WishlistsController < ApplicationController
  load_and_authorize_resource
  before_action :load_wishlist, only: [:show, :edit, :update]

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    if @wishlist.update(wishlist_params)
      redirect_to wishlist_path(@wishlist), notice: 'Successfully updated your wishlist.'
    else
      flash.now[:alert] = 'Something went wrong.'
      render :edit
    end
  end

  def destroy
  end

private

  def load_wishlist
    @wishlist = Wishlist.find_by(id: params[:id])

    if @wishlist.nil?
      redirect_back fallback_location: root_path,
                    alert: "We couldn't find that wishlist."
    end
  end

  def wishlist_params
    params.require(:wishlist).permit(:title)
  end
end

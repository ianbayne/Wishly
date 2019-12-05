class WishlistItemsController < ApplicationController
  load_and_authorize_resource

  def create
    wishlist = Wishlist.find(params[:wishlist_id])
    wishlist_item = wishlist.wishlist_items.new(wishlist_item_params)

    if wishlist_item.save
      flash[:notice] = 'Successfully added an item to your wishlist.'
    else
      flash[:alert] = 'Unable to add new wishlist item.'
    end
    redirect_to edit_wishlist_path(wishlist_item.wishlist)
  end

private

  def wishlist_item_params
    params.require(:wishlist_item).permit(:name)
  end
end

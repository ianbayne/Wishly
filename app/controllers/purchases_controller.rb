class PurchasesController < ApplicationController
  def create
    current_user  = User.find(params[:user_id])
    wishlist_item = WishlistItem.find(params[:id])

    if wishlist_item.purchased?
      redirect_to wishlist_path(wishlist_item.wishlist, user_id: current_user),
        alert: 'Oops! Looks like someone else just purchased that.'
      return
    end

    purchase = Purchase.new(user: current_user, wishlist_item: wishlist_item)

    if wishlist_item.wishlist.owner != current_user && purchase.save
      flash[:notice] = 'Item purchased!'
    else
        flash[:alert] = 'Something went wrong. Unable to purchase item.'
    end

    redirect_to wishlist_path(wishlist_item.wishlist, user_id: current_user)
  end

  def destroy
    current_user  = User.find(params[:user_id])
    wishlist_item = WishlistItem.find(params[:id])
    purchase      = wishlist_item.purchase

    if purchase.user == current_user && purchase.destroy
      flash[:notice] = 'Purchase cancelled.'
    else
      flash[:alert] = 'Something went wrong. Unable to cancel purchase'
    end

    redirect_to wishlist_path(wishlist_item.wishlist, user_id: current_user)
  end
end

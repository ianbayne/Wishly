class PurchasesController < ApplicationController
  def create
    current_user   = User.find(params[:user_id])
    @wishlist_item = WishlistItem.find(params[:id])

    if @wishlist_item.purchased?
      redirect_to wishlist_path(@wishlist_item.wishlist, user_id: current_user),
        alert: 'Oops! Looks like someone else just purchased that.'
      return
    end

    purchase = Purchase.new(user: current_user, wishlist_item: @wishlist_item)

    respond_to do |format|
      if @wishlist_item.wishlist.owner != current_user && purchase.save
        format.js { flash.now[:notice] = 'Item purchased!' }
      else
        format.js do
          flash.now[:alert] = 'Something went wrong. Unable to purchase item.'
        end
      end
    end
  end

  def destroy
    current_user  = User.find(params[:user_id])
    wishlist_item = WishlistItem.find(params[:id])
    purchase      = wishlist_item.purchase

    respond_to do |format|
      if purchase.user == current_user && purchase.destroy
        format.js { flash.now[:notice] = 'Purchase cancelled.' }
      else
        format.js do
          flash.now[:alert] = 'Something went wrong. Unable to cancel purchase'
        end
      end
    end
  end
end

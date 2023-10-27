class PurchasesController < ApplicationController
  before_action :set_current_user

  def create
    @current_user  = User.find(params[:user_id])
    @wishlist_item = WishlistItem.find(params[:id])

    if @wishlist_item.purchased?
      flash[:alert] = 'Oops! Looks like someone else just purchased that.'
      redirect_to wishlist_path(wishlist_item.wishlist, user_id: @current_user), status: 301
      return
    end

    purchase = Purchase.new(user: @current_user, wishlist_item: @wishlist_item)

    if @wishlist_item.wishlist.owner != @current_user && purchase.save
      success_message = 'Item purchased!'

      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = success_message }
        format.html do
          redirect_to wishlist_path(@wishlist_item.wishlist, user_id: @current_user), status: 301,
                                                                                      notice: success_message
        end
      end
    else
      failure_message = 'Something went wrong. Unable to purchase item.'

      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = failure_message }
        format.html do
          redirect_to wishlist_path(@wishlist_item.wishlist, user_id: @current_user), status: :unprocessable_entity,
                                                                                      alert: failure_message
        end
      end
    end
  end

  def destroy
    @current_user  = User.find(params[:user_id])
    @wishlist_item = WishlistItem.find(params[:id])
    @purchase      = @wishlist_item.purchase

    if @purchase.user == @current_user && @purchase.destroy
      success_message = 'Purchase cancelled.'

      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = success_message }
        format.html do
          redirect_to wishlist_path(wishlist_item.wishlist, user_id: @current_user), status: 301,
                                                                                     notice: success_message
        end
      end
    else
      failure_message = 'Something went wrong. Unable to cancel purchase'

      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = failure_message }
        format.html do
          redirect_to wishlist_path(wishlist_item.wishlist, user_id: @current_user), status: :unprocessable_entity,
                                                                                     alert: failure_message
        end
      end
    end
  end

  private

  def set_current_user
    Current.user = User.find(params[:user_id])
  end
end

class WishlistsController < ApplicationController
  # TODO: load_and_authorize_resource for other actions?
  load_and_authorize_resource
  # load_and_authorize_resource only: [:show, :edit]
  before_action :load_wishlist, only: [:show, :edit, :update]

  def show
    @wishlist_items = @wishlist.wishlist_items.includes(:purchased_by)
  end

  def new
    # TODO: Refactor to use form
    # @form = CreateWishlistForm.new
    @wishlist = current_user.build_wishlist
  end

  def create
    # TODO: refactor to use form
    # @form = CreateWishlistForm.new(wishlist_params.merge(current_user: current_user))

    # if @form.save
    #   redirect_to wishlist_path(current_user.wishlist),
    #     notice: 'Successfully created your wishlist'
    # else
    #   render :new, alert: 'Something went wrong'
    # end
    @wishlist = current_user.build_wishlist(wishlist_params)

    if @wishlist.save
      redirect_to wishlist_path(@wishlist),
        notice: 'Successfully created your wishlist'
    else
      render :new, alert: 'Something went wrong'
    end
  end

  def edit
  end

  def update
    if @wishlist.update(wishlist_params)
      redirect_to edit_wishlist_path(@wishlist), notice: 'Successfully updated your wishlist.'
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
    # params.require(:create_wishlist_form).permit(
    #   :title,
    #   :name
    # )
    params.require(:wishlist).permit(
      :title,
      wishlist_items_attributes: [
        :id,
        :name,
        :_destroy
      ]
    )
  end
end

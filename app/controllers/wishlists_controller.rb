class WishlistsController < ApplicationController
  def new
    @wishlist = Wishlist.new
    @wishlist.build_owner
    3.times { @wishlist.wishlist_items.build }
    3.times { @wishlist.invitees.build }
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    if @wishlist.save
      send_emails
      redirect_to wishlist_path(@wishlist), notice: 'Wishlist created!'
    else
      respond_to do |format|
        failure_message = 'Your wishlist could not be created...'
        format.js { flash.now[:alert] = failure_message }
        format.html do
          flash.now[:alert] = failure_message
          render :new
        end
      end
    end
  end

  def show
    @wishlist = Wishlist.find_by(id: params[:id])
  end

private

  def wishlist_params
    params.require(:wishlist).permit(
      :title,
      owner_attributes: [
        :email
      ],
      wishlist_items_attributes: [
        :id,
        :name
      ],
      invitees_attributes: [
        :id,
        :email
      ]
    )
  end

  def send_emails
    owner    = @wishlist.owner
    invitees = @wishlist.invitees

    WishlistMailer.with(wishlist: @wishlist, recipient: owner)
                  .new_wishlist_created.deliver_now

    invitees.each do |invitee|
      WishlistMailer.with(wishlist: @wishlist, recipient: invitee)
                    .invited_to_wishlist.deliver_now
    end
  end
end

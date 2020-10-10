class WishlistsController < ApplicationController
  before_action :authenticate_user, only: [:show, :edit, :update]

  def new
    @wishlist = Wishlist.new
    @wishlist.build_owner
    @wishlist.wishlist_items.build
    @wishlist.invitees.build
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    if @wishlist.save
      send_emails
      redirect_to(
        wishlist_path(@wishlist, user_id: @wishlist.owner.id),
        notice: 'Wishlist created!'
      )
    else
      respond_to do |format|
        failure_message = 'Your wishlist could not be created...'
        format.js { flash.now[:alert] = failure_message }
        # TODO: Fix this (format.html doesn't work)
        format.html do
          flash.now[:alert] = failure_message
          render :new
        end
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    original_items_count = @wishlist.wishlist_items.count
    original_invitees = @wishlist.invitees.to_a

    if @wishlist.update(wishlist_params)
      if original_items_count != @wishlist.wishlist_items.count
        send_wishlist_updated_emails
      end

      new_invitees = @wishlist.invitees.to_a.filter do |invitee|
        !original_invitees.include? invitee
      end

      send_emails(owner: nil, invitees: new_invitees)

      redirect_to(
        wishlist_path(@wishlist, user_id: @wishlist.owner.id),
        notice: 'Wishlist updated!'
      )
    else
      respond_to do |format|
        failure_message = 'Your wishlist could not be updated...'
        format.js { flash.now[:alert] = failure_message }
        # TODO: Fix this (format.html doesn't work)
        format.html do
          flash.now[:alert] = failure_message
          render :new
        end
      end
    end
  end

private

  def wishlist_params
    params.require(:wishlist).permit(
      :id,
      :title,
      owner_attributes: [
        :id,
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

  def send_emails(owner: @wishlist.owner, invitees: @wishlist.invitees)
    if owner
      WishlistMailer.with(wishlist_id: @wishlist.id, recipient_id: owner.id)
                    .new_wishlist_created.deliver_later
    end

    if invitees
      invitees.each do |invitee|
        WishlistMailer.with(wishlist_id: @wishlist.id, recipient_id: invitee.id)
                      .invited_to_wishlist.deliver_later
      end
    end
  end

  def authenticate_user
    @wishlist = Wishlist.find_by(id: params[:id])
    @user     = User.find_by(id: params[:user_id])

    if @wishlist.nil? ||
      (@wishlist.owner != @user && !@wishlist.invitees.include?(@user))
      redirect_to root_path, alert: 'The wishlist you are trying to access ' \
                                    'does not exist or you do not have ' \
                                    'access to it.'
    end
  end

  def send_wishlist_updated_emails
    # TODO
  end
end

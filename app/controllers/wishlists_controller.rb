class WishlistsController < ApplicationController
  before_action :set_wishlist, only: %i[show edit update]
  before_action :ensure_wishlist, except: %i[new create]
  before_action :set_user, only: %i[show edit update]
  before_action :authenticate_user, only: [:show]
  before_action :authenticate_owner, only: %i[edit update]

  def new
    @wishlist = Wishlist.new
    @wishlist.build_owner
    @wishlist.wishlist_items.build
    @wishlist.invitees.build
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    if @wishlist.save
      SendEmails.new(owner: @wishlist.owner, invitees: @wishlist.invitees).call
      redirect_to(wishlist_path(@wishlist, user_id: @wishlist.owner.id), notice: 'Wishlist created!')
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

  def show; end

  def edit; end

  def update
    # TODO: This method is quite big. Refactor into something smaller
    original_items_count = @wishlist.wishlist_items.count
    original_invitees = @wishlist.invitees.to_a

    if @wishlist.update(wishlist_params)
      if original_items_count != @wishlist.wishlist_items.count
        send_wishlist_updated_emails(owner: nil, invitees: @wishlist.invitees)
      end

      new_invitees = @wishlist.invitees.to_a.filter do |invitee|
        !original_invitees.include? invitee
      end

      SendEmails.new(owner: nil, invitees: new_invitees).call
      send_wishlist_updated_emails(invitees: nil)

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
      owner_attributes: %i[
        id
        email
      ],
      wishlist_items_attributes: %i[
        id
        name
        url
      ],
      invitees_attributes: %i[
        id
        email
      ]
    )
  end

  def redirect_to_root
    redirect_to root_path, alert: 'The wishlist you are trying to access ' \
                                  'does not exist or you do not have ' \
                                  'access to it.'
  end

  def set_wishlist
    @wishlist = Wishlist.find_by(id: params[:id])
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def ensure_wishlist
    redirect_to_root if @wishlist.nil?
  end

  def authenticate_user
    redirect_to_root if
      !@wishlist.invitees.include?(@user) && @wishlist.owner != @user
  end

  def authenticate_owner
    redirect_to_root if @wishlist.owner != @user
  end

  def send_wishlist_updated_emails(invitees:, owner: @wishlist.owner)
    if owner
      WishlistMailer.with(wishlist_id: @wishlist.id, recipient_id: owner.id)
                    .own_wishlist_updated.deliver_later
    end

    if invitees
      invitees.each do |invitee|
        WishlistMailer.with(wishlist_id: @wishlist.id, recipient_id: invitee.id)
                      .wishlist_updated.deliver_later
      end
    end
  end
end

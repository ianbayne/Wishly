RailsAdmin.config do |config|
  config.asset_source = :sprockets

  # REF: https://mensfeld.pl/2014/03/ruby-on-rails-railsadmin-http-basic-authentication/
  config.authenticate_with do
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.rails_admin[:username] &&
        password == Rails.application.credentials.rails_admin[:password]
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  # Hides Attachments, Blob, and VariantRecords from /admin
  config.included_models = [
    'Purchase',
    'User',
    'Wishlist',
    'WishlistInvitee',
    'WishlistItem'
  ]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

require 'rails_helper'

RSpec.describe WishlistMailer, type: :mailer do
  let(:owner)    { User.create(email: 'owner@example.com') }
  let(:wishlist) { Wishlist.create(title: 'Example wishlist', owner: owner) }

  describe 'new_wishlist_created' do
    let(:mail) do
      WishlistMailer.with(wishlist: wishlist, recipient: owner)
                    .new_wishlist_created
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('You created a new wishlist!')
      expect(mail.to).to eq([owner.email])
      expect(mail.from).to eq(['support@wishly.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('You can visit your wishlist at ' \
        "any time to update it or to confirm what's on it by clicking")
    end
  end

  describe 'invited_to_wishlist' do
    let(:invitee) { User.create(email: 'invitee@example.com') }
    let(:mail) do
      WishlistMailer.with(wishlist: wishlist, recipient: invitee)
                    .invited_to_wishlist
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Someone invited you to their wishlist!')
      expect(mail.to).to eq([invitee.email])
      expect(mail.from).to eq(['support@wishly.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(
        "#{wishlist.owner.email} has invited you to their wishlist."
      )
    end
  end

end

require 'rails_helper'

RSpec.describe WishlistMailer, type: :mailer do
  let(:owner)    { User.create(email: 'owner@example.com') }
  let(:wishlist) do
      Wishlist.create!(
        title: 'Example wishlist',
        owner: owner,
        wishlist_items: [
          WishlistItem.new(name: 'Item 1')
        ],
        invitees: [
          User.new(email: 'invitee@example.com')
        ]
      )
    end

  let(:new_wishlist_created_mail) do
    WishlistMailer.with(wishlist_id: wishlist.id, recipient_id: owner.id)
                  .new_wishlist_created
  end
  let(:invited_to_wishlist_mail) do
    WishlistMailer.with(
      wishlist_id:  wishlist.id,
      recipient_id: wishlist.invitees.first.id
    ).invited_to_wishlist
  end

  describe 'new_wishlist_created' do
    it 'renders the headers' do
      aggregate_failures do
        expect(new_wishlist_created_mail.subject).to eq('You created a new wishlist!')
        expect(new_wishlist_created_mail.to).to eq([owner.email])
        expect(new_wishlist_created_mail.from).to(
          eq(["wishly-support@#{ActionMailer::Base.smtp_settings[:domain]}"])
        )
      end
    end

    it 'renders the body' do
      expect(new_wishlist_created_mail.body.encoded).to(
        include(
          'You can visit your wishlist at any time to update it or to ' \
          "confirm what's on it by clicking"
        )
      )
    end

    it 'has a unique Message-ID' do
      new_wishlist_created_mail_2 =
        WishlistMailer.with(wishlist_id: wishlist.id, recipient_id: owner.id)
                      .new_wishlist_created

      expect(new_wishlist_created_mail.message_id).not_to(
        eq(new_wishlist_created_mail_2.message_id)
      )
    end
  end

  describe 'invited_to_wishlist' do
    it 'renders the headers' do
      aggregate_failures do
        expect(invited_to_wishlist_mail.subject).to(
          eq('Someone invited you to their wishlist!')
        )
        expect(invited_to_wishlist_mail.to).to(
          eq([wishlist.invitees.first.email])
        )
        expect(invited_to_wishlist_mail.from).to(
          eq(["wishly-support@#{ActionMailer::Base.smtp_settings[:domain]}"])
        )
      end
    end

    it 'renders the body' do
      expect(invited_to_wishlist_mail.body.encoded).to include(
        "#{wishlist.owner.email} has invited you to their wishlist, " \
        "\"#{wishlist.title}.\""
      )
    end

    it 'has a unique Message-ID' do
      invited_to_wishlist_mail_2 = WishlistMailer.with(
                                     wishlist_id:  wishlist.id,
                                     recipient_id: wishlist.invitees.first.id
                                   ).invited_to_wishlist

      expect(invited_to_wishlist_mail.message_id).not_to(
        eq(invited_to_wishlist_mail_2.message_id)
      )
    end
  end

end

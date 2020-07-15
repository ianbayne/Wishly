class Wishlist < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many   :wishlist_items
  has_many   :wishlist_invitees
  has_many   :invitees, through: :wishlist_invitees, source: :user

  accepts_nested_attributes_for :owner
  accepts_nested_attributes_for :wishlist_items,
                                :invitees,
                                reject_if: :all_blank

  validates :title, presence: true
  validates :wishlist_items,
            :invitees,
            length: { minimum: 1 }
  validate  :ensure_gmail_addresses_are_unique

private

  def ensure_gmail_addresses_are_unique
    return if self.owner.nil? || self.owner.email.blank?

    gmail_addresses = []
    gmail_addresses << self.owner.email if self.owner.email.include?('gmail.com')
    self.invitees.each do |invitee|
      gmail_addresses << invitee.email if invitee.email.include?('gmail.com')
    end

    gmail_addresses.compact

    stripped_addresses = []
    gmail_addresses.each do |address|
      address = address.downcase.gsub('.', '')
      stripped_addresses << address
    end

    if stripped_addresses.length != stripped_addresses.uniq.length
      errors.add(:wishlist, 'email addresses must be unique.')
    end
  end
end

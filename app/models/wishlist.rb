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

  EMAIL_RE = Regexp.new(/(?<before_plus>.+)\+(?<after_plus>.+)@(?<domain>.+)/)

private

  def ensure_gmail_addresses_are_unique
    return if self.owner.nil? || self.owner.email.blank?

    gmail_addresses = find_gmail_users
    gmail_addresses.compact
    stripped_addresses = strip_addresses(gmail_addresses)

    if stripped_addresses.length != stripped_addresses.uniq.length
      errors.add(:wishlist, 'email addresses must be unique.')
    end
  end

  def find_gmail_users
    gmail_addresses = []
    gmail_addresses << self.owner.email if self.owner.email.include?('gmail.com')
    self.invitees.each do |invitee|
      gmail_addresses << invitee.email if invitee.email.include?('gmail.com')
    end
    gmail_addresses
  end

  def strip_addresses(addresses)
    stripped_addresses = []
    addresses.each do |address|
      address = strip_periods(address)
      address = strip_part_after_plus_sign(address) if address.include?('+')
      stripped_addresses << address
    end
    stripped_addresses
  end

  def strip_periods(address)
    address.downcase.gsub('.', '')
  end

  def strip_part_after_plus_sign(address)
    matches = address.match(EMAIL_RE)
    address = "#{matches[:before_plus]}@#{matches[:domain]}"
  end
end

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

  validate  :at_least_one_wishlist_item
  validate  :at_least_one_invitee
  validate  :ensure_all_email_addresses_are_unique
  validate  :ensure_gmail_addresses_are_unique

  EMAIL_RE = Regexp.new(/(?<before_plus>.+)\+(?<after_plus>.+)@(?<domain>.+)/)

  def participants
    participants = [self.owner] + self.invitees
    participants.compact
  end

private

  def ensure_all_email_addresses_are_unique
    email_addresses     = self.participants.map(&:email)
    downcased_addresses = email_addresses.map(&:downcase)
    add_error_if_not_unique(downcased_addresses)
  end

  def ensure_gmail_addresses_are_unique
    return if self.owner.nil? || self.owner.email.blank?

    gmail_addresses = find_gmail_users
    gmail_addresses.compact
    stripped_addresses = strip_addresses(gmail_addresses)

    add_error_if_not_unique(stripped_addresses)
  end

  def add_error_if_not_unique(addresses)
    if addresses.length != addresses.uniq.length
      errors.add(:wishlist, 'email addresses must be unique.')
    end
  end

  def find_gmail_users
    email_addresses = self.participants.map(&:email)
    email_addresses.filter { |address| address.include?('gmail.com') }
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

  def at_least_one_wishlist_item
    return if wishlist_items.size > 0

    errors.add :base, :invalid, message: 'You must have at least one item in your wishlist'
  end

  def at_least_one_invitee
    return if invitees.size > 0

    errors.add :base, :invalid, message: 'You must invite at least one person to your wishlist'
  end
end

class Wishlist < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id', dependent: :destroy
  has_many   :wishlist_items, dependent: :destroy
  has_many   :wishlist_invitees, dependent: :destroy
  has_many   :invitees, through: :wishlist_invitees, source: :user

  accepts_nested_attributes_for :owner
  accepts_nested_attributes_for :wishlist_items,
                                :invitees,
                                reject_if: :all_blank

  validates :title,
            :invitees,
            :wishlist_items,
            presence: true

  validate  :ensure_all_email_addresses_are_unique, unless: -> { owner.nil? }
  validate  :ensure_gmail_addresses_are_unique, unless: -> { owner.nil? }

  EMAIL_RE = Regexp.new(/(?<before_plus>.+)\+(?<after_plus>.+)@(?<domain>.+)/)

  def participants_email_addresses
    # Interestingly, `invitees.pluck` and `invitees.select` both return empty arrays.
    # TODO: Look further into this
    email_addresses = [owner.email] + invitees.map(&:email)
    email_addresses.compact
  end

  private

  def ensure_all_email_addresses_are_unique
    downcased_addresses = participants_email_addresses.map(&:downcase)
    add_error_if_not_unique(downcased_addresses)
  end

  def ensure_gmail_addresses_are_unique
    gmail_addresses = find_gmail_users
    gmail_addresses.compact
    stripped_addresses = strip_addresses(gmail_addresses)

    add_error_if_not_unique(stripped_addresses)
  end

  def add_error_if_not_unique(addresses)
    errors.add(:wishlist, 'email addresses must be unique.') if addresses.length != addresses.uniq.length
  end

  def find_gmail_users
    participants_email_addresses.filter { |address| address.include?('gmail.com') }
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

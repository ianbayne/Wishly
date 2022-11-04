class WishlistItem < ApplicationRecord
  before_save :add_url_protocol

  belongs_to :wishlist
  has_one :purchase, dependent: :destroy

  validates :name, presence: true

  def purchased?
    !!purchase
  end

private

  def add_url_protocol
    return if url.blank? || url_protocol_present?

    self.url = "https://#{url}"
  end

  def url_protocol_present?
    url[/\Ahttps?:\/\//]
  end
end

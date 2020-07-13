class User < ApplicationRecord
  validates :email, presence: true
  validate  :ensure_no_gmail_duplicates

private

  def ensure_no_gmail_duplicates
    return if self.email.blank?

    email = self.email.match /(?<username>.+)@(?<domain>.+)/
    return if email[:domain] != 'gmail.com'

    if email[:username].include?('.') || email[:username].include?('+')
      errors.add(
        :email,
        "cannot contain periods or the plus sign because it's a Gmail address."
      )
    end
  end
end

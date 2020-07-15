require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new }

  it 'is valid with an email' do
    user.email = 'user@example.com'
    user.save

    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    expect(user).to_not be_valid
  end
end


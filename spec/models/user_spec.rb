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

  context 'when a gmail address' do
    it 'cannot contain periods' do
      user.email = 'example.name@gmail.com'
      user.save

      aggregate_failures do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to(
          include "Email cannot contain periods or the plus sign because it's " \
                  'a Gmail address.'
        )
      end
    end

    it 'cannot contain the plus sign' do
      user.email = 'example+name@gmail.com'
      user.save

      aggregate_failures do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to(
          include "Email cannot contain periods or the plus sign because it's " \
                  'a Gmail address.'
        )
      end
    end
  end

  it 'can contain periods or the plus sign when not a Gmail addresses' do
    user.email = 'example.name+test@hotmail.com'
    user.save

    expect(user).to be_valid
  end
end


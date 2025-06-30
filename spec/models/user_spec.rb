require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without an email' do
    user = User.new(password: 'password123', password_confirmation: 'password123')
    expect(user).not_to be_valid
    expect(user.errors[:email]).to be_present
  end
end

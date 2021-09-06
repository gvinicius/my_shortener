require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.create(
      email: 'test@example.com',
      password: 'password123',
    )
  end

  before do
    create(:link, user: user)
  end

  it 'is database authenticable' do
    expect(user.valid_password?('password123')).to be_truthy
  end

  it 'counts the correct number of links for a user' do
    expect(user.links.count).to eq(1)
  end
end

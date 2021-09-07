# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:some_difficult_pass) { '13o12okepokwopdasifm3tASDSAF,l@@' }
  let(:user) do
    create(:user, password: some_difficult_pass)
  end

  before do
    create(:link, user: user)
  end

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:username) }

  it 'is database authenticable' do
    expect(user.valid_password?(some_difficult_pass)).to be_truthy
  end

  it 'counts the correct number of links for a user' do
    expect(user.links.count).to eq(1)
  end

  it 'does not accepts repetition in usernames' do
    new_user = user.dup
    # Let's change just the email
    new_user.email = Faker::Internet.email

    expect(new_user).to_not be_valid
  end
end

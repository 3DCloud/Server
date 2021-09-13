# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session, type: :model do
  let(:user) { create(:user) }

  it 'is valid with all required values' do
    expect(Session.new(
      user: user,
      jti: SecureRandom.hex(32),
      expires_at: DateTime.now.utc + 15.minutes,
    )).to be_valid
  end

  it 'is not valid without a user' do
    expect(Session.new(
      jti: SecureRandom.hex(32),
      expires_at: DateTime.now.utc + 15.minutes,
    )).to be_invalid
  end

  it 'is not valid without a jti' do
    expect(Session.new(
      user: user,
      expires_at: DateTime.now.utc + 15.minutes,
    )).to be_invalid
  end

  it 'is not valid without an expiry date' do
    expect(Session.new(
      user: user,
      jti: SecureRandom.hex(32),
    )).to be_invalid
  end
end

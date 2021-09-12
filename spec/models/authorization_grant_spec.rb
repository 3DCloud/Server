# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizationGrant, type: :model do
  setup do
    @user = create(:user)
  end

  it 'is valid with all required attributes' do
    expect(AuthorizationGrant.new(
      user: @user,
      authorization_code: 'abcd1234',
      code_challenge: 'efgh5678',
      expires_at: DateTime.now.utc + 1.minute
    )).to be_valid
  end

  it 'is not valid without a user' do
    expect(AuthorizationGrant.new(
      authorization_code: 'abcd1234',
      code_challenge: 'abcd1234',
      expires_at: DateTime.now.utc + 1.minute
    )).to be_invalid
  end

  it 'is not valid without an authorization code' do
    expect(AuthorizationGrant.new(
      user: @user,
      code_challenge: 'abcd1234',
      expires_at: DateTime.now.utc + 1.minute
    )).to be_invalid
  end

  it 'is not valid without a code challenge' do
    expect(AuthorizationGrant.new(
      user: @user,
      authorization_code: 'abcd1234',
      expires_at: DateTime.now.utc + 1.minute
    )).to be_invalid
  end

  it 'is not valid without an expiry date' do
    expect(AuthorizationGrant.new(
      user: @user,
      authorization_code: 'abcd1234',
      code_challenge: 'efgh5678',
    )).to be_invalid
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with all required values' do
    expect(User.new(
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234'
    )).to be_valid
  end

  it 'is not valid without a name' do
    expect(User.new(
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234'
    )).to be_invalid
  end

  it 'is not valid without a username' do
    expect(User.new(
      name: 'Name',
      email_address: 'me@example.com',
      sso_uid: '1234'
    )).to be_invalid
  end

  it 'is not valid without an email address' do
    expect(User.new(
      name: 'Name',
      username: 'username000',
      sso_uid: '1234'
    )).to be_invalid
  end

  it 'is not valid without a single sign-on ID' do
    expect(User.new(
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
    )).to be_invalid
  end

  it 'is not valid when there is a duplicate single sign-on ID' do
    User.new(
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234'
    ).save!

    expect(User.new(
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234'
    )).to be_invalid
  end

  it 'creates a valid user from a SAML response' do
    user = User.get_or_create_from_saml_response('1234', OneLogin::RubySaml::Attributes.new({
      'name' => ['Name'],
      'username' => ['username000'],
      'email_address' => ['me@example.com'],
    }))

    expect(user).to be_valid
    expect(user.name).to eq('Name')
    expect(user.username).to eq('username000')
    expect(user.email_address).to eq('me@example.com')
    expect(user.sso_uid).to eq('1234')
  end
end

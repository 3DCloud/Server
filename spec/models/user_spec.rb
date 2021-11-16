# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_data) {
    {
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234',
      role: 'regular_user',
    }
  }

  it 'is valid with all required values' do
    expect(User.new(valid_data)).to be_valid
  end

  %w(name username email_address sso_uid role).each do |attribute|
    it "is invalid when #{attribute} is missing" do
      expect(User.new(valid_data.except!(attribute.to_sym))).to be_invalid
    end
  end

  it 'is not valid when there is a duplicate single sign-on ID' do
    User.new(
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234',
      role: 'regular_user',
    ).save!

    expect(User.new(
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com',
      sso_uid: '1234',
      role: 'admin',
    )).to be_invalid
  end

  it 'creates a valid user from a SAML response' do
    user = User.get_or_create_from_saml_response('1234', OneLogin::RubySaml::Attributes.new({
      'name' => ['Name'],
      'username' => ['username000'],
      'email_address' => ['me@example.com'],
      'role' => ['regular_user'],
    }))

    expect(user).to be_valid
    expect(user.name).to eq('Name')
    expect(user.username).to eq('username000')
    expect(user.email_address).to eq('me@example.com')
    expect(user.sso_uid).to eq('1234')
    expect(user.role).to eq('regular_user')
  end
end

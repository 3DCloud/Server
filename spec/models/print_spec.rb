# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Print, type: :model do
  let(:printer) { create(:printer) }
  let(:uploaded_file) { create(:uploaded_file) }

  it 'is invalid if printer is missing' do
    expect(Print.new(
      status: 'pending',
      uploaded_file: uploaded_file,
    )).to be_invalid
  end

  it 'is invalid if uploaded_file is missing' do
    expect(Print.new(
      status: 'pending',
      printer: printer,
    )).to be_invalid
  end

  it 'is invalid if status is not valid' do
    expect(Print.new(
      status: 'potato',
      printer: printer,
      uploaded_file: uploaded_file,
      started_at: DateTime.now.utc,
      completed_at: DateTime.now.utc,
    )).to be_invalid
  end
end

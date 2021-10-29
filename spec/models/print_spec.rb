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

  describe 'started_at' do
    it 'is optional when status is pending' do
      expect(Print.new(
        status: 'pending',
        printer: printer,
        uploaded_file: uploaded_file,
      )).to be_valid
    end

    %w(downloading running success canceled errored).each do |status|
      it "is required when status is #{status}" do
        expect(Print.new(
          status: status,
          printer: printer,
          uploaded_file: uploaded_file,
        )).to be_invalid
      end
    end
  end

  describe 'created_at' do
    %w(pending downloading running).each do |status|
      it "is optional when status is #{status}" do
        expect(Print.new(
          status: status,
          printer: printer,
          uploaded_file: uploaded_file,
          started_at: DateTime.now.utc,
        )).to be_valid
      end
    end

    %w(success canceled errored).each do |status|
      it "is required when status is #{status}" do
        expect(Print.new(
          status: status,
          printer: printer,
          uploaded_file: uploaded_file,
          started_at: DateTime.now.utc,
        )).to be_invalid
      end
    end
  end
end

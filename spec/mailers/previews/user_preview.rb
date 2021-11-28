# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def print_canceled_email
    UserMailer.with(print: FactoryBot.build(:print, :canceled)).print_canceled_email
  end

  def print_completed_email
    UserMailer.with(print: FactoryBot.build(:print)).print_completed_email
  end

  def print_failed_email
    UserMailer.with(print: FactoryBot.build(:print)).print_failed_email
  end
end

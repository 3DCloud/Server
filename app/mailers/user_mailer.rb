# frozen_string_literal: true

class UserMailer < ApplicationMailer
  before_action do
    attachments.inline['header_logo.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'email_header_logo.png'))
  end

  def print_canceled_email
    @print = params[:print]

    mail(to: @print.user.email_address, subject: "Your print \"#{@print.uploaded_file.filename}\" has been canceled")
  end

  def print_completed_email
    @print = params[:print]

    mail(to: @print.user.email_address, subject: "Your print \"#{@print.uploaded_file.filename}\" has completed successfully")
  end

  def print_failed_email
    @print = params[:print]

    mail(to: @print.user.email_address, subject: "Your print \"#{@print.uploaded_file.filename}\" has failed")
  end
end

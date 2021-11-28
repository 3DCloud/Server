# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'MakerRepo Print <print@makerepo.com>'
  helper :mail
end

# frozen_string_literal: true

module ApplicationCable
  class ApplicationCableError < StandardError; end
  class CommunicationError < ApplicationCableError; end
  class AcknowledgementError < ApplicationCableError; end
end

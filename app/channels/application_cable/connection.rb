module ApplicationCable
  class Connection < ActionCable::Connection::Base
    rescue_from StandardError, with: :report_error

    def connect
      logger.info "connected"
    end

    private

    def report_error(e)
      logger.error e
    end
  end
end

class ClientsChannel < ApplicationCable::Channel
  def subscribed
    logger.info "subscribed!"
    stream_for "all"
    stream_for params["guid"]
    logger.info params
  end

  def printer_state(args)
    logger.info args["timestamp"]

    args["printer_states"].each do |id, printer|
      logger.info "#{id} => #{printer}"
    end
  end
end
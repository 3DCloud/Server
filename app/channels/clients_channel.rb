class ClientsChannel < ApplicationCable::Channel
  def subscribed
    logger.info "subscribed!"
    stream_for "all"
    stream_for params["guid"]
    logger.info params
  end

  def sample_action(args)
    logger.info args["message"]
    broadcast_to "all", { sample_property: "value of sample_property" }
  end
end
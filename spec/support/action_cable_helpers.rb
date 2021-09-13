# frozen_string_literal: true

RSpec::Matchers.define :have_broadcasted_message do |target, expected|
  attr_reader :expected

  match do |channel|
    message = ActionCable.server.pubsub.broadcasts(channel.broadcasting_for(target)).last

    @expected = expected
    @actual = if message
      JSON.parse(message)
    else
      nil
    end

    @actual == @expected
  end

  diffable
end

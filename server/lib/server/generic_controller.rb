class GenericController
  ### Session variable keys ###

  S_KEY_RULESET = :ruleset
  S_KEY_CURRENT_SS_ID = Dispatcher::S_KEY_CURRENT_SS_ID
  S_KEY_CURRENT_PLANET_ID = Dispatcher::S_KEY_CURRENT_PLANET_ID
  S_KEY_CURRENT_PLANET_SS_ID = :current_planet_ss_id

  class << self
    def required(hash); ParamOpts.required(hash); end
    def valid(list); ParamOpts.valid(list); end
    def only_push; ParamOpts.only_push; end
    def logged_in; ParamOpts.logged_in; end
    def control_token; ParamOpts.control_token; end
    def no_options; ParamOpts.no_options; end

    def scope; Dispatcher::Scope; end

    # Associate player to client which sent this message.
    def login(message, player)
      typesig binding, Dispatcher::Message, Player

      player.last_seen = Time.now
      player.save!

      atomic! do
        # If this player was connected from other session this will disconnect
        # the old session.
        dispatcher.set_player!(message.client, player)
        set_ruleset(message, player.galaxy.ruleset)
      end

      # TODO: spec
      hub = Chat::Pool.instance.hub_for(player)
      # Wait until other thread disconnects player from chat hub to prevent
      # this scenario:
      # A) connect & register
      # B) unregister & disconnect
      # Result: Player connected but not registered to chat.
      if hub.connected?(player)
        LOGGER.info(
          "Reconnect to chat, waiting until old player disconnects from hub."
        )
        sleep(0.01) while hub.connected?(player)
        LOGGER.info "Old player has disconnected from chat hub, continuing."
      end
      # Register to chat hub. This needs to be done on the same thread as
      # players|login action, because we need to ensure register has finished
      # before pushing chat|index.
      #
      # Also only register to hub if player is still connected to dispatcher.
      # Otherwise we might register a player while he has been disconnected in
      # dispatcher thread, which would lead to player being unable to login
      # because of check that is done above.
      hub.register(player) if dispatcher.player_connected?(player.id)

      true
    end

    # Respond to clients message.
    def respond(message, params={})
      typesig binding, Dispatcher::Message, Hash

      dispatcher.respond!(message, params)
    end

    # Push message to client who sent message.
    def push(message, action, params={})
      typesig binding, Dispatcher::Message, String, Hash

      dispatcher.push!(message.client, action, params.stringify_keys)
    end

    # Disconnect client who sent message.
    def disconnect(message, reason=nil)
      typesig binding, Dispatcher::Message, [NilClass, String]

      dispatcher.disconnect!(message.client, reason)
    end

    ### Session variables ###

    def session_get(message, key)
      dispatcher.storage_get(message, key)
    end
    def session_set(message, key, value)
      dispatcher.storage_set(message, key, value)
    end

    # Galaxy ruleset player is in.
    def ruleset(message)
      session_get(message, S_KEY_RULESET)
    end
    def set_ruleset(message, value)
      session_set(message, S_KEY_RULESET, value)
    end

    # Solar system ID which is currently viewed by client.
    def current_ss_id(message)
      session_get(message, S_KEY_CURRENT_SS_ID)
    end
    def set_current_ss_id(message, value)
      session_set(message, S_KEY_CURRENT_SS_ID, value)
    end

    # SsObject ID which is currently viewed by client.
    def current_planet_id(message)
      session_get(message, S_KEY_CURRENT_PLANET_ID)
    end
    def set_current_planet_id(message, value)
      session_set(message, S_KEY_CURRENT_PLANET_ID, value)
    end

    # Solar System ID of planet which is currently viewed by client.
    def current_planet_ss_id(message)
      session_get(message, S_KEY_CURRENT_PLANET_SS_ID)
    end
    def set_current_planet_ss_id(message, value)
      session_set(message, S_KEY_CURRENT_PLANET_SS_ID, value)
    end

    # Send all messages from this block to dispatcher in an atomic block.
    # Does not support messages that get back values!
    def atomic!
      begin
        Thread.current[:atomizer] = Dispatcher::Atomizer.new
        yield
        Celluloid::Actor[:dispatcher].atomic!(Thread.current[:atomizer])
      ensure
        Thread.current[:atomizer] = nil
      end
    end

    private
    def dispatcher
      if Thread.current[:atomizer]
        Thread.current[:atomizer]
      else
        Celluloid::Actor[:dispatcher]
      end
    end
  end
end

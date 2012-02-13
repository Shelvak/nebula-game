class GenericController
  ### Session variable keys ###

  S_KEY_RULESET = :ruleset
  S_KEY_CURRENT_SS_ID = :current_ss_id
  S_KEY_CURRENT_PLANET_ID = :current_planet_id
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

      dispatcher.set_player!(message.client, player)
      set_ruleset(message, player.galaxy.ruleset)
    end

    # Respond to clients message.
    def respond(message, params={})
      typesig binding, Dispatcher::Message, Hash

      dispatcher.transmit!(
        {"action" => message.full_action, "params" => params}, message.client
      )
    end

    # Push message to client who sent message.
    def push(message, action, params={})
      typesig binding, Dispatcher::Message, String, Hash

      dispatcher.push!(message.client, action, params)
    end

    # Disconnect client who sent message.
    def disconnect(message, reason=nil)
      typesig binding, Dispatcher::Message, [NilClass, String]

      dispatcher.disconnect!(message.client, reason)
    end

    ### Session variables ###

    def session_get(message, key)
      dispatcher.storage_get(message.client, key)
    end
    def session_set(message, key, value)
      dispatcher.storage_set(message.client, key, value)
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

    private
    def dispatcher; Celluloid::Actor[:dispatcher]; end
  end
end

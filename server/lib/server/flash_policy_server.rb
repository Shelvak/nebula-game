module FlashPolicyServer
  include LoggingServer
  include FlashPolicyHandler
  
  def receive_data(data)
    debug "Received #{data.inspect} from client."
    if flash_policy_request?(data)
      respond_with_policy
      debug "Sending #{str.inspect} to client."
    else
      debug "Wrong request."
    end

    close_connection_after_writing
  end

  def to_s
    "FlashPolicyServer-#{object_id}"
  end
end

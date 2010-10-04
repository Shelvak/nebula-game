module FlashPolicyServer
  include LoggingServer
  
  def receive_data(data)
    debug "Received #{data.inspect} from client."
    if data.strip == "<policy-file-request/>"
      # Write server policy
      str =<<EOF
<?xml version='1.0'?>
<!DOCTYPE cross-domain-policy SYSTEM
'http://www.adobe.com/xml/dtds/cross-domain-policy.dtd'>

<cross-domain-policy>
  <site-control permitted-cross-domain-policies='master-only'/>
  <allow-access-from domain='*' to-ports='#{CONFIG['game']['port']}' />
</cross-domain-policy>\0
EOF
      str.strip!
      debug "Sending #{str.inspect} to client."
      send_data str
    else
      debug "Wrong request."
    end

    close_connection_after_writing
  end

  def to_s
    "FlashPolicyServer-#{object_id}"
  end
end

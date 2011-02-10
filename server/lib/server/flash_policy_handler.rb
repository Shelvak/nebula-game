module FlashPolicyHandler
  def flash_policy_request?(data)
    data.strip == "<policy-file-request/>"
  end

  def respond_with_policy
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
    send_data str
  end
end

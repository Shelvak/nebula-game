require 'digest/sha1'

Factory.define :combat_log do |m|
  m.sha1_id { Digest::SHA1.hexdigest(Time.now.to_f.to_s) }
  m.info("foo" => "bar", "player_count" => 10)
end
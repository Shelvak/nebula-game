Factory.define :galaxy do |m|
  m.ruleset GameConfig::DEFAULT_SET
  m.callback_url "localhost"
  m.pool_free_zones 1
  m.pool_free_home_ss 5
end
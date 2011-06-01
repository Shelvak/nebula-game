Factory.define :galaxy do |m|
  m.ruleset GameConfig::DEFAULT_SET
  m.callback_url "localhost"
end
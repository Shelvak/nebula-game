class GameConfig::ScalaWrapper
  include Java::spacemule.modules.config.ScalaConfig

  IllegalArgumentException = Java::java.lang.IllegalArgumentException

  def initialize(config)
    @config = config
  end

  # def get[T](key: String, set: String): T
  def get(key, ruleset)
    value = @config[key, ruleset]
    raise IllegalArgumentException.new("Cannot find config key #{key.inspect
      } in ruleset #{ruleset}!") if value.nil?
    value.to_scala
  end

  # def getOpt[T](key: String, set: String): Option[T]
  def getOpt(key, ruleset)
    value = @config[key, ruleset]
    value.nil? ? None : Some(value.to_scala)
  end
end
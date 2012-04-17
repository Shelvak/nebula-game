class GameConfig::ScalaWrapper
  include Java::spacemule.modules.config.ScalaConfig

  IllegalArgumentException = Java::java.lang.IllegalArgumentException

  # def get[T](key: String): T
  def get(key)
    value = CONFIG[key]
    raise IllegalArgumentException,
      "Cannot find config key #{key.inspect}!" if value.nil?
    value.to_scala
  end

  # def getOpt[T](key: String): Option[T]
  def getOpt(key)
    value = CONFIG[key]
    value.nil? ? None : Some(value.to_scala)
  end
end
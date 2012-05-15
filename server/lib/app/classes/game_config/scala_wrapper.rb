class GameConfig::ScalaWrapper
  include Java::spacemule.modules.config.ScalaConfig

  # def get(key: String): IRubyObject
  def get(key); CONFIG[key]; end
end
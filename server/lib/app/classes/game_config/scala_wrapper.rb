class GameConfig::ScalaWrapper
  include Java::spacemule.modules.config.ScalaConfig

  #def any(key: String): Option[Any]
  def any(key)
    value = CONFIG[key]
    value.nil? ? None : Some(value.to_java)
  end

  #def int(key: String): Option[Int]
  def int(key)
    value = CONFIG[key]
    check_value!(key, value, Fixnum)
    value.nil? ? None : Some(value.to_java(:int))
  end

  #def float(key: String): Option[Float]
  def float(key)
    value = CONFIG[key]
    check_value!(key, value, Float)
    value.nil? ? None : Some(value.to_java(:float))
  end

  #def double(key: String): Option[Double]
  def double(key)
    value = CONFIG[key]
    check_value!(key, value, Float)
    value.nil? ? None : Some(value.to_java(:double))
  end

  #def string(key: String): Option[String]
  def string(key)
    value = CONFIG[key]
    check_value!(key, value, String)
    value.nil? ? None : Some(value.to_java)
  end

  #def symbol(key: String): Option[Symbol]
  def symbol(key)
    value = CONFIG[key]
    check_value!(key, value, Symbol)
    value.nil? ? None : Some(Java::scala.Symbol.apply(value.to_s))
  end

  #def boolean(key: String): Option[Boolean]
  def boolean(key)
    value = CONFIG[key]
    check_value!(key, value, Boolean)
    value.nil? ? None : Some(value.to_java(:boolean))
  end

  #def array[T](key: String): Option[sc.Seq[T]]
  def array(key)
    value = CONFIG[key]
    check_value!(key, value, Array)
    value.nil? ? None : Some(Java::jruby.ListWrapper.new(value))
  end

  #def hash[K, V](key: String): Option[sc.Map[K, V]]
  def hash(key)
    value = CONFIG[key]
    check_value!(key, value, Hash)
    value.nil? ? None : Some(Java::jruby.MapWrapper.new(value))
  end

private

  def check_value!(key, value, kind)
    typesig_bindless [["value", value]], [NilClass, kind]
  rescue ArgumentError => e
    raise e.class, "Error while fetching #{key}:\n#{e.message}", e.backtrace
  end
end
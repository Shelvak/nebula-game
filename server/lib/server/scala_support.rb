# Scala <-> Ruby interoperability.
class Object
  def to_scala
    case self
    when Hash
      scala_hash = Java::scala.collection.mutable.HashMap.new
      each do |key, value|
        scala_hash.update(key.to_scala, value.to_scala)
      end
      scala_hash
    when Set
      scala_set = Java::scala.collection.mutable.HashSet.new
      each { |item| scala_set.send(:"+=", item.to_scala) }
      scala_set
    when Array
      scala_array = Java::scala.collection.mutable.ArrayBuffer.new
      each { |value| scala_array += value.to_scala }
      scala_array
    when Symbol
      to_s
    else
      self
    end
  end

  def from_scala
    case self
    when Java::scala.collection.Map, Java::scala.collection.immutable.Map,
        Java::scala.collection.mutable.Map
      ruby_hash = {}
      foreach { |tuple| ruby_hash[tuple._1.from_scala] = tuple._2.from_scala }
      ruby_hash
    when Java::scala.collection.Set, Java::scala.collection.immutable.Set,
        Java::scala.collection.mutable.Set
      ruby_set = Set.new
      foreach { |item| ruby_set.add item.from_scala }
      ruby_set
    when Java::scala.collection.Seq
      ruby_array = []
      foreach { |item| ruby_array.push item.from_scala }
      ruby_array
    when Java::scala.Product
      if self.class.to_s.match /Tuple\d+$/
        # Conversion from scala Tuples.
        ruby_array = []
        productIterator.foreach { |item| ruby_array.push item.from_scala }
        ruby_array
      else
        self
      end
    else
      self
    end
  end
end

module Kernel
  def Some(value); Java::scala.Some.new(value); end
  None = Java::spacemule.helpers.JRuby.None

  def add_exception_info(exception, message)
    raise exception.class, message + "\n\n" + exception.message,
      exception.backtrace
  end
end
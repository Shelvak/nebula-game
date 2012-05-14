package spacemule.helpers

import org.jruby.runtime.builtin.IRubyObject
import org.jruby._
import scala.{collection => sc}
import collection.JavaConversions._
import collection.mutable.{Buffer, Map, Set}
import exceptions.RaiseException
import javasupport.JavaUtil
import _root_.java.{util => ju}
import runtime.Block
import scala.Boolean

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/7/12
 * Time: 2:11 PM
 * To change this template use File | Settings | File Templates.
 */

object JRuby {
  private[this] var _ruby: Ruby = null
  def ruby =
    if (_ruby == null)
      throw new IllegalStateException("JRuby runtime hasn't been set yet!")
    else
      _ruby

  def rbContext = ruby.getCurrentContext

  /**
   * This should be set from Ruby side.
   *
   * require 'jruby'
   * Java::spacemule.helpers.JRuby.ruby = JRuby.runtime
   * @param runtime
   **/
  def setRuby(runtime: Ruby) { _ruby = runtime }

  def RClass(name: String) = ruby.getClass(name)

  def RSet(set: sc.Set[_]) = ruby.getClass("ScalaSupport::Set").
    newInstance(rbContext, any2Rb(set), Block.NULL_BLOCK)

  implicit def pimpRubyObj(obj: IRubyObject) = new IRubyObjToScala(obj)
  implicit def int2Rb(int: Int) = JavaUtil.convertJavaToRuby(ruby, int)
  implicit def long2Rb(long: Long) = JavaUtil.convertJavaToRuby(ruby, long)
  implicit def any2Rb(any: Any) = JavaUtil.convertJavaToRuby(ruby, any)
  implicit def sym2rbSym(symbol: Symbol) =
    RubySymbol.newSymbol(ruby, symbol.name)

  /**
   * This is needed, because from JRuby Java::scala.None is actually something
   * different than None obtained from Scala in such way.
   *
   * >> Java::scala.None
   * => Java::Scala::None
   * >> Java::spacemule.helpers.JRuby.None
   * => #<#<Class:0x10060d664>:0x69a54c>
   */
  val None = scala.None

  // Scala-Ruby Array
  class SRArray(val raw: RubyArray) extends Buffer[IRubyObject] {
    class Iterator extends scala.Iterator[IRubyObject] {
      private[this] var index = 0

      def hasNext = index < raw.size()

      def next() = {
        val element = raw.eltOk(index)
        index += 1
        element
      }
    }

    def update(n: Int, newelem: IRubyObject) {
      raw.set(n, newelem)
    }

    def +=(elem: IRubyObject) = {
      raw.add(elem)
      this
    }

    def clear() {
      raw.clear()
    }

    def +=:(elem: IRubyObject) = {
      raw.add(0, elem)
      this
    }

    def insertAll(n: Int, elems: Traversable[IRubyObject]) {
      raw.addAll(n, elems.toList)
    }

    def remove(n: Int) = raw.remove(n).asInstanceOf[IRubyObject]

    def length = raw.size()

    def apply(idx: Int) =
      if (idx < 0 || idx >= length)
        throw new NoSuchElementException(
          "Invalid index "+idx+" (max index: "+(length - 1)+")"
        )
      else
        raw.eltOk(idx)

    def iterator = new Iterator

    override def repr = this
  }

  // Scala-Ruby Set. There is actually no Java backend object for that, so we
  // just abuse the Ruby code!
  class SRSet[T](
    val raw: IRubyObject,
    rubyToScala: IRubyObject => T,
    scalaToRuby: T => IRubyObject
  ) extends Set[T] {
    class Iterator extends scala.Iterator[T] {
      private[this] lazy val enumerator = raw.callMethod(context, "each")

      def hasNext = try {
        RubyEnumerator.peek(context, enumerator).asBoolean
      }
      catch {
        case e: RaiseException =>
          if (
            e.getException.getMetaClass.getRealClass ==
            runtime.getClass("StopIteration")
          ) false
          else throw e
      }

      def next() = rubyToScala(RubyEnumerator.next(context, enumerator))
    }

    override def empty = new SRSet[T](
      raw.getMetaClass.newInstance(context, Block.NULL_BLOCK),
      rubyToScala, scalaToRuby
    )

    def contains(elem: T) =
      raw.callMethod(context, "include?", scalaToRuby(elem)).asBoolean

    def +=(elem: T) = {
      raw.callMethod(context, "add", scalaToRuby(elem))
      this
    }

    def -=(elem: T) = {
      raw.callMethod(context, "delete", scalaToRuby(elem))
      this
    }

    override def size = raw.callMethod(context, "size").asInt

    override def repr = this

    def iterator = new Iterator

    private[this] def runtime = raw.getRuntime
    private[this] def context = runtime.getCurrentContext
  }

  // Scala-Ruby Hash
  class SRHash[K, V](
    val raw: RubyHash,
    keyRubyToScala: IRubyObject => K,
    valRubyToScala: IRubyObject => V,
    keyScalaToRuby: K => IRubyObject,
    valScalaToRuby: V => IRubyObject
  ) extends Map[K, V] {
    class Iterator extends scala.Iterator[(K, V)] {
      private[this] lazy val rubyIter = raw.directEntrySet().iterator()

      def hasNext = rubyIter.hasNext

      def next() = {
        val entry = rubyIter.next.asInstanceOf[
          ju.Map.Entry[IRubyObject, IRubyObject]
        ]
        (keyRubyToScala(entry.getKey), valRubyToScala(entry.getValue))
      }
    }

    def +=(kv: (K, V)) = {
      raw.put(keyScalaToRuby(kv._1), valScalaToRuby(kv._2))
      this
    }

    def -=(key: K) = {
      raw.remove(keyScalaToRuby(key))
      this
    }

    override def apply(key: K): V = raw.fastARef(any2Rb(key)) match {
      case null => throw new NoSuchElementException("unknown key: " + key)
      case obj: Any => valRubyToScala(obj.asInstanceOf[IRubyObject])
    }

    // Type erasure does not allow us to define this as get() :(
    def by(key: Any): Option[V] = raw.fastARef(any2Rb(key)) match {
      case null => None
      case obj: IRubyObject => Some(valRubyToScala(obj))
    }

    def get(key: K) = by(key)

    override def size = raw.size()

    def iterator = new Iterator

    override def repr = this
  }
}

class IRubyObjToScala(obj: IRubyObject) {
  def asInt: Int = obj match {
    case fn: RubyFixnum => fn.getLongValue.toInt
    case d: RubyFloat => d.getLongValue.toInt
    case bn: RubyBignum => sys.error("Cannot fit "+bn+" to Int!")
    case _ => throw conversionError("Int")
  }

  def asLong: Long = obj match {
    case fn: RubyFixnum => fn.getLongValue
    case d: RubyFloat => d.getLongValue
    case bn: RubyBignum => sys.error("Cannot fit "+bn+" to Long!")
    case _ => throw conversionError("Long")
  }

  def asBigInteger: BigInt = obj match {
    case fn: RubyFixnum => new BigInt(fn.getBigIntegerValue)
    case d: RubyFloat => new BigInt(d.getBigIntegerValue)
    case bn: RubyBignum => new BigInt(bn.getBigIntegerValue)
    case _ => throw conversionError("Bignum")
  }

  def asBoolean: Boolean = obj match {
    case b: RubyBoolean => b.isTrue
    case _ => throw conversionError("Boolean")
  }

  def asFloat: Float = obj match {
    case f: RubyFixnum => f.getDoubleValue.toFloat
    case f: RubyFloat => f.getValue.toFloat
    case _ => throw conversionError("Float")
  }

  def asDouble: Double = obj match {
    case f: RubyFixnum => f.getDoubleValue
    case f: RubyFloat => f.getValue
    case _ => throw conversionError("Double")
  }

  def asSymbol: Symbol = obj match {
    case s: RubySymbol => Symbol(s.toString)
    case _ => throw conversionError("Symbol")
  }

  def asArray: JRuby.SRArray = obj match {
    case a: RubyArray => new JRuby.SRArray(a)
    case _ => throw conversionError("Buffer")
  }

  def asMap[K, V](
    keyRubyToScala: IRubyObject => K, valRubyToScala: IRubyObject => V,
    keyScalaToRuby: K => IRubyObject, valScalaToRuby: V => IRubyObject
  ): JRuby.SRHash[K, V] = obj match {
    case h: RubyHash => new JRuby.SRHash[K, V](
      h, keyRubyToScala, valRubyToScala, keyScalaToRuby, valScalaToRuby
    )
    case _ => throw conversionError("Map")
  }

  def asMap: JRuby.SRHash[IRubyObject, IRubyObject] = obj match {
    case h: RubyHash => new JRuby.SRHash[IRubyObject, IRubyObject](
      h,
      obj => obj, obj => obj,
      obj => obj, obj => obj
    )
    case _ => throw conversionError("Map")
  }

  def asSet[T](
    rubyToScala: IRubyObject => T,
    scalaToRuby: T => IRubyObject
  ): JRuby.SRSet[T] =
    if (obj.getMetaClass.getRealClass == obj.getRuntime.getClass("Set"))
      new JRuby.SRSet[T](obj, rubyToScala, scalaToRuby)
    else throw conversionError("Set")

  def asSet: JRuby.SRSet[IRubyObject] = asSet(item => item, item => item)

  def unwrap[T]: T = obj.toJava(AnyRef.getClass).asInstanceOf[T]

  private[this] def conversionError(className: String): Exception =
    new RuntimeException("Cannot convert %s of class %s to %s!".format(
      obj.inspect().toString, obj.getMetaClass.getRealClass.toString, className
    ))
}
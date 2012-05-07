package spacemule.helpers

import org.jruby.runtime.builtin.IRubyObject
import org.jruby._
import collection.JavaConversions._
import collection.mutable.{Buffer, Map}
import exceptions.RaiseException
import javasupport.JavaUtil
import org.jruby.RubyHash.RubyHashEntry
import runtime.Block
import scala.Boolean
import spacemule.helpers.JRuby.SRHash

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/7/12
 * Time: 2:11 PM
 * To change this template use File | Settings | File Templates.
 */

class IRubyObjToScala(obj: IRubyObject) {
  def asInt: Int = obj match {
    case fn: RubyFixnum => fn.getLongValue.toInt
    case d: RubyFloat => d.getLongValue.toInt
    case bn: RubyBignum => sys.error("Cannot fit "+bn+" to Int!")
    case _ => throw conversionError("Int")
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

  def asMap: JRuby.SRHash = obj match {
    case h: RubyHash => new JRuby.SRHash(h)
    case _ => throw conversionError("Map")
  }

  def asSet: JRuby.SRSet =
    if (obj.getMetaClass.getRealClass == obj.getRuntime.getClass("Set"))
      new JRuby.SRSet(obj)
    else throw conversionError("Set")

  private[this] def conversionError(className: String): Exception =
    new RuntimeException("Cannot convert %s of class %s to %s!".format(
      obj.inspect().toString, obj.getMetaClass.getRealClass.toString, className
    ))
}

class RubyHashExtensions(obj: RubyHash) {
  def asMap = new SRHash(obj)

  def asScalaMap[K, V](
    keyTransformer: (IRubyObject) => K,
    valTransformer: (IRubyObject) => V
  ): Map[K, V] = {
    val map = Map.empty[K, V]
    val iter = obj.entrySet().iterator()
    while (iter.hasNext) {
      val entry = iter.next().asInstanceOf[RubyHashEntry]
      val key = entry.getKey.asInstanceOf[IRubyObject]
      val value = entry.getValue.asInstanceOf[IRubyObject]
      map(keyTransformer(key)) = valTransformer(value)
    }

    map
  }
}

object JRuby {
  implicit def pimpRubyObj(obj: IRubyObject) = new IRubyObjToScala(obj)
  implicit def pimpRubyHash(obj: RubyHash) = new RubyHashExtensions(obj)

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
  class SRSet(val raw: IRubyObject) extends Set[IRubyObject] {
    class Iterator extends scala.Iterator[IRubyObject] {
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

      def next() = RubyEnumerator.next(context, enumerator)
    }

    override def empty = new SRSet(
      raw.getMetaClass.newInstance(context, Block.NULL_BLOCK)
    )

    def contains(elem: IRubyObject) =
      raw.callMethod(context, "include?", elem).asBoolean

    def +(elem: IRubyObject) = new SRSet(raw.callMethod(context, "+", elem))

    def -(elem: IRubyObject) = new SRSet(raw.callMethod(context, "-", elem))

    override def size = raw.callMethod(context, "size").asInt

    override def repr = this

    def iterator = new Iterator

    private[this] def runtime = raw.getRuntime
    private[this] def context = runtime.getCurrentContext
  }

  // Scala-Ruby Hash
  class SRHash(val raw: RubyHash)
    extends Map[IRubyObject, IRubyObject]
  {
    class Iterator extends scala.Iterator[(IRubyObject, IRubyObject)] {
      private[this] lazy val rubyIter = raw.directEntrySet().iterator()

      def hasNext = rubyIter.hasNext

      def next() = {
        val entry = rubyIter.next.asInstanceOf[RubyHashEntry]
        (
          entry.getKey.asInstanceOf[IRubyObject],
          entry.getValue.asInstanceOf[IRubyObject]
        )
      }
    }

    def +=(kv: (IRubyObject, IRubyObject)) = {
      raw.put(kv._1, kv._2)
      this
    }

    def -=(key: IRubyObject) = {
      raw.remove(key)
      this
    }

    def apply(key: AnyRef) = raw.fastARef(rbKey(key)) match {
      case null => throw new NoSuchElementException("unknown key: " + key)
      case obj: AnyRef => obj.asInstanceOf[IRubyObject]
    }

    // Type erasure does not allow us to define this as get() :(
    def by(key: AnyRef) = raw.fastARef(rbKey(key)) match {
      case null => None
      case obj: IRubyObject => Some(obj)
    }

    def get(key: IRubyObject) = by(key)

    override def size = raw.size()

    def iterator = new Iterator

    override def repr = this

    private[this] def rbKey(key: AnyRef) =
      JavaUtil.convertJavaToUsableRubyObject(raw.getRuntime, key)
  }
}
package spacemule.helpers

import org.jruby.runtime.builtin.IRubyObject
import org.jruby._

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/16/12
 * Time: 11:52 AM
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
   * Java::jruby.JRuby.runtime = JRuby.runtime
   **/
  def setRuntime(runtime: Ruby) { _ruby = runtime }

  def RClass(name: String) = ruby.getClass(name)
  def RModule(name: String) = ruby.getModule(name)

  implicit def extendIRubyObject(obj: IRubyObject) =
    new IRubyObjectExtensions(obj)
}

class IRubyObjectExtensions(obj: IRubyObject) {
  def call(name: String) = obj.callMethod(
    obj.getRuntime.getCurrentContext, name
  )

  def unwrap[T] = obj.toJava(classOf[AnyRef]).asInstanceOf[T]

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

  private[this] def conversionError(className: String): Exception =
    new RuntimeException("Cannot convert %s of class %s to %s!".format(
      obj.inspect().toString, obj.getMetaClass.getRealClass.toString, className
    ))
}

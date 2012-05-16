package jruby

import org.jruby.javasupport.JavaUtil
import org.jruby.runtime.builtin.IRubyObject
import org.jruby.{RubySymbol, Ruby}
import java.{util => ju}

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/16/12
 * Time: 11:16 AM
 * To change this template use File | Settings | File Templates.
 */

object JRuby {
  /**
   * Wraps object into scala collection wrappers if it is a ruby collection.
   *
   * @param obj
   * @tparam T
   * @return
   */
  def wrapRubyCollection[T](obj: Any): T = (obj match {
    case l: ju.List[_] =>
      new ListWrapper[AnyRef](l.asInstanceOf[ju.List[AnyRef]])
    case m: ju.Map[_, _] =>
      new MapWrapper[AnyRef, AnyRef](m.asInstanceOf[ju.Map[AnyRef, AnyRef]])
    case o: IRubyObject if (SetWrapper.isRubySet(o)) =>
      new SetWrapper[AnyRef](o)
    case x: Any => x
    case null => null
  }).asInstanceOf[T]

  implicit def extendIRubyObject(obj: IRubyObject) =
    new IRubyObjectExtensions(obj)
//  implicit def int2Rb(int: Int) = JavaUtil.convertJavaToRuby(ruby, int)
//  implicit def long2Rb(long: Long) = JavaUtil.convertJavaToRuby(ruby, long)
  implicit def any2Rb(any: Any, ruby: Ruby) =
    JavaUtil.convertJavaToRuby(ruby, any)
//  implicit def sym2rbSym(symbol: Symbol) =
//    RubySymbol.newSymbol(ruby, symbol.name)

  /**
   * Just a crazy hack, to avoid this:
   * >> Java::scala.Some.new(3)
   * ArgumentError: wrong number of arguments (0 for 1)
   *
   * @param value
   * @tparam T
   * @return
   */
  def createSome[T](value: T) = Some(value)

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
}

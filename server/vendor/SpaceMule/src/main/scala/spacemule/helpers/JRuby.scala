package spacemule.helpers

import org.jruby.Ruby

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
   * @param runtime
   **/
  def setRuntime(runtime: Ruby) { _ruby = runtime }

  def RClass(name: String) = ruby.getClass(name)
  def RModule(name: String) = ruby.getModule(name)
}

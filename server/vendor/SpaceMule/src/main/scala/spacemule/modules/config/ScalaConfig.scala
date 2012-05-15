package spacemule.modules.config

import org.jruby.runtime.{Block, ThreadContext}
import java.util.List
import org.jruby.runtime.builtin.{Variable, IRubyObject}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/3/12
 * Time: 2:48 PM
 * To change this template use File | Settings | File Templates.
 */

trait ScalaConfig {
  def get(key: String): IRubyObject
}

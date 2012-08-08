/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/8/12
 * Time: 11:20 AM
 * To change this template use File | Settings | File Templates.
 */
package models.sound {
   public class MSound {
      [Bindable]
      public var name: String;
      [Bindable]
      public var source: String;
      public function MSound(_name: String, _source: String) {
         name = _name;
         source = _source;
      }
   }
}

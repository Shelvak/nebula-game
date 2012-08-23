/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/23/12
 * Time: 1:29 PM
 * To change this template use File | Settings | File Templates.
 */
package components.movement.speedInfoTooltip {
   public class MUnitSpeed {
      [Bindable]
      public var name: String;

      [Bindable]
      public var galaxyHopTime: String;

      [Bindable]
      public var ssHopTime: String;

      [Bindable]
      public var isSlowest: Boolean = false;

      public function MUnitSpeed(_name: String,
                                  _galaxyHopTime: String,
                                  _ssHopTime: String) {
         name = _name;
         galaxyHopTime = _galaxyHopTime;
         ssHopTime = _ssHopTime;
      }
   }
}

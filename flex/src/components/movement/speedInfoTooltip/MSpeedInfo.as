/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/23/12
 * Time: 1:14 PM
 * To change this template use File | Settings | File Templates.
 */
package components.movement.speedInfoTooltip {
   import config.Config;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.ArrayUtil;

   import utils.StringUtil;

   public class MSpeedInfo {
      [Bindable]
      public var names: ArrayCollection;
      public function MSpeedInfo(unitNames: Object) {
         var temp: Object = {};
         var slowestUnit: MUnitSpeed;
         var slowestDefault: int;
         if (unitNames == null)
         {
            return;
         }
         for (var type: String in unitNames)
         {
            var name: String = unitNames[type];
            var defaultGalaxyTime: int = StringUtil.evalFormula(
               Config.getUnitGalaxyHopTime(type));
            var defaultSSTime: int = StringUtil.evalFormula(
               Config.getUnitSSHopTime(type));
            var unitSpeed: MUnitSpeed = new MUnitSpeed(name,
                                 Unit.getJumpTime(defaultGalaxyTime, type),
                                 Unit.getJumpTime(defaultSSTime, type));
            temp[name] = unitSpeed;
            if (slowestUnit == null || slowestDefault < defaultGalaxyTime)
            {
               slowestUnit = unitSpeed;
               slowestDefault = defaultGalaxyTime;
            }
         }
         slowestUnit.isSlowest = true;
         names = new ArrayCollection(ArrayUtil.fromObject(temp, true));
      }
   }
}

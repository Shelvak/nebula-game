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
      public function MSpeedInfo(units: ListCollectionView) {
         var temp: Object = {};
         var slowestUnit: MUnitSpeed;
         var slowestDefault: int;
         for each (var unit: Unit in units)
         {
            var name: String = unit.name;
            if (temp[name] == null)
            {
               var defaultGalaxyTime: int = StringUtil.evalFormula(
                  Config.getUnitGalaxyHopTime(unit.type));
               var defaultSSTime: int = StringUtil.evalFormula(
                  Config.getUnitSSHopTime(unit.type));
               var unitSpeed: MUnitSpeed = new MUnitSpeed(name,
                                    Unit.getJumpTime(defaultGalaxyTime, unit.type),
                                    Unit.getJumpTime(defaultSSTime, unit.type));
               temp[name] = unitSpeed;
               if (slowestUnit == null || slowestDefault < defaultGalaxyTime)
               {
                  slowestUnit = unitSpeed;
                  slowestDefault = defaultGalaxyTime;
               }
            }
         }
         slowestUnit.isSlowest = true;
         names = new ArrayCollection(ArrayUtil.fromObject(temp, true));
      }
   }
}

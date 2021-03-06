package models.parts
{
   import controllers.objects.ObjectClass;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.unit.Unit;
   
   
   public class UnitUpgradable extends Upgradable
   {
      private var ML:ModelLocator = ModelLocator.getInstance();
      
      
      public function UnitUpgradable(parent:IUpgradableModel)
      {
         super(parent);
      }
      
      
      public override function forceUpgradeCompleted(level:int=0) : void
      {
		  //unit is always constructed to level 1, other levels are reached through units|updated
         if (ML.latestPlanet != null)
         {
            var unit: Unit = Unit(parent);
            var constructor: Building = ML.latestPlanet.getBuildingByConstructable(unit.id, ObjectClass.UNIT);
            if (constructor != null)
            {
               unit.flank = constructor.buildIn2ndFlank?1:0;
            }
         }
         super.forceUpgradeCompleted(1);
      }
      
      
      protected override function calcUpgradeTimeImpl(params:Object) : Number
      {
         return calculateUpgradeTime(UpgradableType.UNITS, Unit(parent).type,
                                     {"level": params.level}, Unit(parent).constructionMod);
      }
      
      protected override function get upgradableType():String
      {
         return UpgradableType.UNITS;
      }
      
//      private function dispatchUpgradeFinishedEvent() : void
//      {
//         new UpgradeEvent(UpgradeEvent.UPGRADE_FINISHED);
//      }
//      
//      private function dispatchUpgradablePropChangeEvent() : void
//      {
//         dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_PROP_CHANGE));
//      }
      
   }
}
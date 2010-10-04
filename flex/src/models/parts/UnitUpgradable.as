package models.parts
{
   import config.Config;
   
   import globalevents.GUnitEvent;
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelLocator;
   import models.unit.Unit;
   
   import utils.StringUtil;
   
   public class UnitUpgradable extends Upgradable
   {
      public function UnitUpgradable(parent:IUpgradableModel)
      {
         super(parent);
      }
      
      
      public override function forceUpgradeCompleted(level:int=0) : void
      {
		  //unit is always constructed to level 1, other levels are reached through units|updated
         super.forceUpgradeCompleted(1);
         if (ModelLocator.getInstance().latestPlanet != null)
         {
            ModelLocator.getInstance().latestPlanet.dispatchUnitRefreshEvent();
         }
         //new GUnitEvent(GUnitEvent.UNIT_BUILT);
      }
      
      protected override function calcUpgradeTimeImpl(params:Object) : Number
      {
         return Upgradable.getUpgradeTimeWithConstructionMod(
            StringUtil.evalFormula(
               Config.getUnitUpgradeTime((parent as Unit).type),
               {"level": params.level}
            ),
            (parent as Unit).constructionMod
         ) * 1000;
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
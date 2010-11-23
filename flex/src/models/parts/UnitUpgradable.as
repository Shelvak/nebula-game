package models.parts
{
   import config.Config;
   
   import models.ModelLocator;
   import models.unit.Unit;
   
   import utils.StringUtil;
   
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
         super.forceUpgradeCompleted(1);
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
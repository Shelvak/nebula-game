package models.parts
{
   import models.ModelLocator;
   import models.parts.events.UpgradeEvent;
   import models.technology.Technology;
   
   import utils.DateUtil;

   public class TechnologyUpgradable extends Upgradable
   {
      public function TechnologyUpgradable(parent:IUpgradableModel)
      {
         super(parent);
      }
      
      
      public override function forceUpgradeCompleted(level:int=0) : void
      {
         super.forceUpgradeCompleted(level);
         (parent as Technology).pauseRemainder = 0;
         (parent as Technology).scientists = 0;
         (parent as Technology).pauseScientists = 0;
         dispatchUpgradablePropChangeEvent();
         dispatchUpgradeFinishedEvent();
         ModelLocator.getInstance().resourcesMods.recalculateMods();
      }
      
      
      [Bindable(event="upgradePropChange")]
      public override function get timeToFinishString(): String
      {
         if ((parent as Technology).pauseRemainder == 0)
            return super.timeToFinishString;
         return DateUtil.secondsToHumanString((parent as Technology).pauseRemainder);
      }
      
      public override function calcUpgradeTime(params:Object) : Number
      {
         if (params.scientists == null) 
         {
            params.scientists = (parent as Technology).scientists - (parent as Technology).minScientists;
         }
         return super.calcUpgradeTime(params);
      }
      

      public override function get upgradeProgress() : Number
      {
         dispatchUpgradablePropChangeEvent();
         if ((parent as Technology).pauseRemainder == 0)
            return super.upgradeProgress;
         
         return ((parent as Technology).getUpgradeTimeInSec() - (parent as Technology).pauseRemainder) / 
            (parent as Technology).getUpgradeTimeInSec();
      }
      
      
      protected override function calcUpgradeTimeImpl(params:Object) : Number
      {
         return calculateUpgradeTime(UpgradableType.TECHNOLOGIES, Technology(parent).type, params);
      }
      
      
      private function dispatchUpgradeFinishedEvent() : void
      {
         dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_FINISHED));
      }
      
      private function dispatchUpgradablePropChangeEvent() : void
      {
         if (hasEventListener(UpgradeEvent.UPGRADE_PROP_CHANGE))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_PROP_CHANGE));
         }
      }
   }
}
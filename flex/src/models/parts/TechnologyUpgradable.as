package models.parts
{
   import config.Config;
   
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
         var scientists: int = (params.scientists == null? (parent as Technology).scientists : params.scientists);
         var speedUp: Boolean = (params.speedUp != null? params.speedUp : (parent as Technology).speedUp);
         params.speedUp = null;
         params.scientists = null;
         return Math.floor(super.calcUpgradeTime(params) * ((100 - 
            calculateTimeReduction(scientists,
                                   (parent as Technology).minScientists))/100)/
            (speedUp ? Config.getTechnologiesSpeedUpBoost() : 1));
      }
      
      public static function calculateTimeReduction(scientists: int, minScientists: int): Number
      {
         var additionalScientists: int = scientists - minScientists;
         var timeReduction: Number = (additionalScientists > 0
            ? additionalScientists/minScientists * 100 * Config.getAdditionalScientists()
            : 0);
         timeReduction = Math.max(timeReduction, Config.getMaxTimeReduction());
         return timeReduction;
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
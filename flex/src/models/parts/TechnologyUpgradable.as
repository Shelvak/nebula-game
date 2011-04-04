package models.parts
{
   import config.Config;
   
   import flash.errors.IllegalOperationError;
   
   import models.ModelLocator;
   import models.parts.events.UpgradeEvent;
   import models.technology.Technology;
   
   import mx.controls.Alert;
   
   import utils.DateUtil;
   import utils.StringUtil;

   public class TechnologyUpgradable extends Upgradable
   {
      public static const SCIENTISTS_MIN: String = 'scientists.min';
      
      public static const MOD: String = 'mod.';
      
      public function TechnologyUpgradable(parent:IUpgradableModel)
      {
         super(parent);
      }
      
      public static function getMod(type: String, level: int, kind: String): int
      {
         return Math.round(Upgradable.evalUpgradableFormula(UpgradableType.TECHNOLOGIES, type, MOD+kind,
            {'level': level}));
      }
      
      public static function getMinScientists(type: String, level: int = 1): int
      {
         if (level == 0)
            level = 1;
         return Math.round(StringUtil.evalFormula(Config.getTechnologyProperty(type, SCIENTISTS_MIN), 
            {'level': level}));
      }
      
      public override function forceUpgradeCompleted(level:int=0) : void
      {
         super.forceUpgradeCompleted(level);
         Technology(parent).pauseRemainder = 0;
         Technology(parent).scientists = 0;
         Technology(parent).pauseScientists = 0;
         dispatchUpgradablePropChangeEvent();
         dispatchUpgradeFinishedEvent();
         ModelLocator.getInstance().resourcesMods.recalculateMods();
      }
      
      
      [Bindable(event="upgradePropChange")]
      public override function get timeToFinishString(): String
      {
         if (Technology(parent).pauseRemainder == 0)
            return super.timeToFinishString;
         return DateUtil.secondsToHumanString(Technology(parent).pauseRemainder);
      }
      
      public override function calcUpgradeTime(params:Object) : Number
      {
         var scientists: int = (params.scientists == null? Technology(parent).scientists : params.scientists);
         var speedUp: Boolean = (params.speedUp != null? params.speedUp : Technology(parent).speedUp);
         params.speedUp = null;
         params.scientists = null;
         return Math.max(1, reduceUpgradeTime(super.calcUpgradeTime(params), scientists, 
            Technology(parent).minScientists, speedUp));
      }
      
      public static function calculateTechUpgradeTime(type: String, level: int, scientists: int, minScientists: int,
                                                      speedUp: Boolean): Number
      {
         return Math.max(reduceUpgradeTime(Upgradable.calculateUpgradeTime(UpgradableType.TECHNOLOGIES, type, {'level': level}),
         scientists, minScientists, speedUp));
      }
      
      private static function reduceUpgradeTime(oldUpgradeTime: Number, scientists: int, minScientists: int,
                                               speedUp: Boolean): int
      {
         return Math.floor(oldUpgradeTime * ((100 - calculateTimeReduction(scientists, minScientists))/100)/
            (speedUp ? Config.getTechnologiesSpeedUpBoost() : 1));
      }
      
      public static function calculateTimeReduction(scientists: int, minScientists: int): Number
      {
         var additionalScientists: int = scientists - minScientists;
         var timeReduction: Number = (additionalScientists > 0
            ? additionalScientists/minScientists * 100 * Config.getAdditionalScientists()
            : 0);
         timeReduction = Math.min(timeReduction, Config.getMaxTimeReduction());
         return timeReduction;
      }
      

      public override function get upgradeProgress() : Number
      {
         dispatchUpgradablePropChangeEvent();
         if (Technology(parent).pauseRemainder == 0)
            return super.upgradeProgress;
         
         return (Technology(parent).getUpgradeTimeInSec() - Technology(parent).pauseRemainder) / 
            Technology(parent).getUpgradeTimeInSec();
      }
      
      
      protected override function calcUpgradeTimeImpl(params:Object) : Number
      {
         return calculateUpgradeTime(UpgradableType.TECHNOLOGIES, Technology(parent).type, params);
      }
      
      
      public override function timeNeededForNextLevel() : Number
      {
         throw new IllegalOperationError("This method is not supported");
      }
      
      protected override function get upgradableType():String
      {
         return UpgradableType.TECHNOLOGIES;
      }
      
      
      public function dispatchUpgradeFinishedEvent() : void
      {
         if (hasEventListener(UpgradeEvent.UPGRADE_FINISHED))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_FINISHED));
         }
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
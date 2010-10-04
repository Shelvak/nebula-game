package models.technology
{
   import com.developmentarc.core.utils.EventBroker;
   
   import config.Config;
   
   import flash.events.Event;
   
   import globalevents.GTechnologiesEvent;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.building.Building;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.TechnologyUpgradable;
   import models.parts.Upgradable;
   import models.parts.events.UpgradeEvent;
   
   import mx.resources.ResourceManager;
   
   import utils.DateUtil;
   import utils.StringUtil;

   [ResourceBundle ('Technologies')]
   
   /**
    * Dispatched on the model, when upgrade of technology model
    * has finished.
    * 
    * @eventType models.parts.events.UpgradeEvent.UPGRADE_FINISHED
    */
   [Event(name="upgradeFinished", type="models.parts.events.UpgradeEvent")]
   
   /**
    * Dispatched when <code>level</code> property has changed.
    * 
    * @eventType models.parts.events.UpgradeEvent.LVL_CHANGE
    */
   [Event(name="lvlChange", type="models.parts.events.UpgradeEvent")]

   [Bindable]
   public class Technology extends BaseModel implements IUpgradableModel
   {      
      
      include "../mixins/upgradableProxyProps.as"; 
      
      [Required]
      public var type: String;
      
      [Required]
      public var scientists: int;
      
      [Required]
      public var pauseScientists: int;
      
      [Required]
      public var pauseRemainder: int = 0;
      
      public function Technology()
      {
         _upgradePart = new TechnologyUpgradable(this);
         EventBroker.subscribe(GTechnologiesEvent.TECHNOLOGY_LEVEL_CHANGED, dispatchValidChangeEvent);
         addEventListener(UpgradeEvent.LVL_CHANGE, handleLevelChange);
		 _upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROGRESS, handleProgressChange);
      }
      
      private var _upgradePart:TechnologyUpgradable;
      [Bindable("willNotChange")]
      public function get upgradePart() : Upgradable
      {
         return _upgradePart;
      }
      
      [Bindable (event="technologyCreated")]
      public function get title(): String
      {
         return getTechnologyTitle(type);
      }
      
      public function get coords(): Object
      {
         return Config.getTechnologyCoords(type);
      }
      
      [Bindable(event="upgradeProgress")]
      public function getNewTimeToFinishString(newScientists: int): String
      {
         var remainder: Number = 0;
		 var oldSci: Number = 0;
         if (pauseRemainder > 0)
         {
            remainder = pauseRemainder;
			oldSci = pauseScientists;
         }
         else
         {
            remainder = (upgradePart.upgradeEndsAt.time - upgradePart.lastUpdate.time)/1000;
			oldSci = scientists;
         }
         var timeLeft: Number = remainder * 
            (upgradePart.calcUpgradeTime({'scientists' : newScientists})/upgradePart.calcUpgradeTime({'scientists' :oldSci }));
         return DateUtil.secondsToHumanString(timeLeft < 1?1: int(timeLeft));
      }
      
      
      private static function getTechnologyTitle(type: String): String
      {
         return ResourceManager.getInstance().getString('Technologies', type + ".name");
      }
	  
	  [Bindable (event="selectedTechnologyChanged")]
	  public function get requirementsText():String{
		  var tempText: String = new String();
        var groupText: String = new String();
        var requirements: Object = Config.getTechnologyRequirements(type);
        for (var requirement: String in requirements)
        {
           if (tempText == "")
              tempText += ResourceManager.getInstance().getString ('Technologies', 'required')+':'+ "\n";
           if (!requirements[requirement].invert)        
           {
              tempText = tempText + getTechnologyTitle(requirement)+ " " + 
                 ResourceManager.getInstance().getString('Technologies', 'level', 
                    [requirements[requirement].level.toString()]) + "\n";
           }
           else
           {
              if (groupText == "")
                 groupText += ResourceManager.getInstance().getString('Technologies', 'isGroup') + "\n";
              groupText += getTechnologyTitle(requirement) + "\n";
           }
              
        }

		  return tempText + groupText;
	  }
     
     [Bindable (event="validationChange")]
      public function get isValid():Boolean 
      {
         return technologyIsValid(type);	
      }
      
      public static function technologyIsValid(technologyType: String = null):Boolean
      {
         return Requirement.isValid(Config.getTechnologyRequirements(technologyType));
      }
      
      public function getUpgradeTimeInSec(): int
      {
         return int(StringUtil.evalFormula(Config.getTechnologyUpgradeTime(type), 
            {'level' : upgradePart.level + 1,
             'scientists' : pauseScientists,
             'scientists_min' : minScientists}));
      }
      
      public function getPauseProgress(): Number
      {
         return getUpgradeTimeInSec() - pauseRemainder / getUpgradeTimeInSec();
      }
      
      public function getInfoData(): Object{
         return Config.getTechnologyProperties(type);
      }
      
      public function get description(): String
      {
         return ResourceManager.getInstance().getString('Technologies', type + '.about');
      };
      
      [Bindable (event="selectedTechnologyChanged")]
      public function get maxLevel(): int
      {
         return Config.getTechnologyMaxLevel(type);
      }
      
      public function get minScientists(): int
      {
         return Config.getTechnologyMinScientists(type);
      }
      
      private function handleLevelChange(e: UpgradeEvent): void
      {
         ModelLocator.getInstance().constructable = Building.getConstructableBuildings();
         new GTechnologiesEvent(GTechnologiesEvent.TECHNOLOGY_LEVEL_CHANGED);
      }
	  
	  
	  private function handleProgressChange(e: UpgradeEvent): void
	  {
		  dispatchEvent(new Event(UpgradeEvent.UPGRADE_PROGRESS));
	  }
	  
	  
      
      private function dispatchValidChangeEvent(e: Event): void
      {
         dispatchEvent(new Event('validationChange'));
      }
      
   }
}
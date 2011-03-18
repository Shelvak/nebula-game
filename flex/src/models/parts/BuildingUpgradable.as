package models.parts
{
   import models.ModelLocator;
   import models.building.Building;
   
   import utils.DateUtil;
   
   
   public class BuildingUpgradable extends Upgradable
   {
      /**
       * Calculates hit points for the given building.
       * 
       * @param buildingType type of a building
       * @param level level at which hit points must be calculated
       * 
       * @return hit points
       */
      public static function calculateHitPoints(buildingType:String, level:int) : Number
      {
         if (level == 0)
         {
            return 0;
         }
         return evalUpgradableFormula(UpgradableType.BUILDINGS, buildingType, "hp", {"level": level});
      }
      
      public static function getConstructionMod(buildingType: String, level: int): Number
      {
         return Math.round(evalUpgradableFormula(UpgradableType.BUILDINGS, buildingType, 'mod.construction', 
            {"level": level}));
      }
      
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      
      
      public function BuildingUpgradable(parent:IUpgradableModel)
      {
         super(parent);
      }
      
      
      public static function getUpgradeTimeHumanString(type:String,
                                                       constructionMod:Number = 0,
                                                       level:int = 0) : String
      {
         return DateUtil.secondsToHumanString(
            calculateUpgradeTime(UpgradableType.BUILDINGS, type,
                                 {"level": level + 1}, constructionMod)
         );
      }
      
      protected override function get upgradableType():String
      {
         return UpgradableType.BUILDINGS;
      }
      
      public override function forceUpgradeCompleted(level:int=0) : void
      {
         super.forceUpgradeCompleted(level);
         Building(parent).state = Building.ACTIVE;
         if (ML.latestPlanet)
         {
            ML.latestPlanet.dispatchBuildingUpgradedEvent();
         }
      }
      
      
      protected override function calcUpgradeTimeImpl(params:Object) : Number
      {
         return calculateUpgradeTime(UpgradableType.BUILDINGS, Building(parent).type,
                                     {"level": params.level}, Building(parent).constructionMod);
      }
   }
}
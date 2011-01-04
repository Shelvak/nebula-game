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
      
      
      protected override function beforeUpgradeProgressUpdate(nowServer:Number) : void
      {
         var building:Building = (parent as Building);
         var hpDiff:int = calcHitPoints(level + 1) - calcHitPoints();
         var nominator:int = (nowServer - lastUpdate.time) * hpDiff;
         var denominator:int = calcUpgradeTime({"level": level + 1});
         
         building.incrementHp(nominator / denominator);
         hpRemainder += nominator % denominator;
         
         if (hpRemainder >= denominator)
         {
            building.incrementHp(hpRemainder / denominator);
            hpRemainder = hpRemainder % denominator
         }
         
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
      
      
      /**
       * A property for accumulating hp error during upgrade process. This property
       * is used by internal class methods and you should not change it except in situations
       * when instance of a <code>Building</code> needs to be synced with data on the server.
       * 
       * @default 0
       */
      public var hpRemainder:int = 0;
      
      
      /**
       * Calculates hit points of a building of a given level. If you don't
       * provide <code>level</code> parameter value in <code>this.level</code>
       * will be used instead.
       * 
       * @param level Level of a building.
       * 
       * @return HP value of this building when it is of the given level.  
       */      
      protected function calcHitPoints(level:int = -1) : int
      {
         if (level < 0)
         {
            level = this.level;
         }
         return calculateHitPoints(Building(parent).type, level);
      }
   }
}
package models.parts
{
   import config.Config;
   
   import models.ModelLocator;
   import models.building.Building;
   
   import utils.StringUtil;
   
   public class BuildingUpgradable extends Upgradable
   {
      public function BuildingUpgradable(parent:IUpgradableModel)
      {
         super(parent);
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
         (parent as Building).state = Building.ACTIVE;
         if (ModelLocator.getInstance().latestPlanet != null)
         {
            ModelLocator.getInstance().latestPlanet.dispatchBuildingUpgradedEvent();
         }
      }
      
      
      protected override function calcUpgradeTimeImpl(params: Object) : Number
      {
         return Upgradable.getUpgradeTimeWithConstructionMod(
            StringUtil.evalFormula(
               Config.getBuildingUpgradeTime((parent as Building).type),
               {"level": params.level}
            ),
            (parent as Building).constructionMod
         ) * 1000;
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
         var hp:int = level == 0 ? 0 : StringUtil.evalFormula(
            Config.getBuildingHp((parent as Building).type),
            {"level": level}
         );
         return hp;
      }
   }
}
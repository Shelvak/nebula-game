package models.notification.parts
{
   import config.Config;
   
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   
   import mx.collections.ArrayCollection;
   
   import utils.Localizer;
   import utils.MathUtil;
   
   
   public class CombatLog extends BaseModel implements INotificationPart
   {
      
      public function CombatLog(params:Object = null)
      {
         super();
         if (params != null)
         {
            location = BaseModel.createModel(Location, params.location);
            logId = params.logId;
            outcome = params.outcome;
            units = params.units;
            leveledUp = new ArrayCollection(params.leveledUp);
            alliancePlayers = params.alliances;
            damageDealtPlayer = params.statistics.damageDealtPlayer;
            damageDealtAlliance = params.statistics.damageDealtAlliance;
            damageTakenPlayer = params.statistics.damageTakenPlayer;
            damageTakenAlliance = params.statistics.damageTakenAlliance;
            xpEarned = params.statistics.xpEarned;
            pointsEarned = params.statistics.pointsEarned;
            metal = MathUtil.round(params.resources.metal, Config.getRoundingPrecision());
            energy = MathUtil.round(params.resources.energy, Config.getRoundingPrecision());
            zetium = MathUtil.round(params.resources.zetium, Config.getRoundingPrecision());
         }
      }
      
      public var logId: String;
      
      public var location: Location;
      
      public var outcome: int;
      
      public var units: Object; //+
      
      public var alliancePlayers: Object; //+
      
      public var leveledUp: ArrayCollection;
      
      public var damageDealtPlayer: int;
      
      public var damageDealtAlliance: int;
      
      public var damageTakenPlayer: int;
      
      public var damageTakenAlliance: int;
      
      public var xpEarned: int;
      
      public var pointsEarned: int;
      
      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.combatLog");
      }
      
      
      public function get message() : String
      {
         return Localizer.string('Notifications', 'message.combatLog', [location.shortDescription]);
      }
   }
}
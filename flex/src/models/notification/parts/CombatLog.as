package models.notification.parts
{
   import config.Config;
   
   import models.BaseModel;
   import models.building.Building;
   import models.factories.BuildingFactory;
   import models.location.Location;
   import models.location.LocationType;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   
   import mx.collections.ArrayCollection;
   
   import utils.MathUtil;
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   public class CombatLog extends BaseModel implements INotificationPart
   {
      
      public function CombatLog(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            var params: Object = notif.params;
            location = Objects.create(Location, params.location);
            buildingType = params.buildingType;
            if (buildingType != null)
            {
               fakeNpcBuilding = BuildingFactory.createDefault(buildingType);
               buildingAttackerId = params.buildingAttackerId;
            }
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
            victoryPointsEarned = params.statistics.victoryPointsEarned;
            credsEarned = params.statistics.credsEarned;
            metal = MathUtil.round(params.resources.metal, Config.getRoundingPrecision());
            energy = MathUtil.round(params.resources.energy, Config.getRoundingPrecision());
            zetium = MathUtil.round(params.resources.zetium, Config.getRoundingPrecision());
         }
      }
      
      public var logId: String;
      
      public var location: Location;

      private var buildingType: String;
      public var fakeNpcBuilding: Building = null;
      private var buildingAttackerId: int = 0;
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
      
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
      
      public var victoryPointsEarned: int;

      public var credsEarned: int;

      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.combatLog");
      }

      private function get normalMessage() : String
      {
         return Localizer.string('Notifications', 'message.combatLog',
            [location.isGalaxy
               ?'galaxy'
               :(location.isBattleground
                  ?'battleground'
                  :(location.isSolarSystem
                     ?'ss'
                     :'planet')),
               location.isSSObject
               ?location.planetName
               :(location.isSolarSystem
                  ?location.solarSystemName
                  :''),
               location.isSSObject
               ?location.player.name
               :'']);
      }

      private function get npcBuildingMessage() : String
      {
            return Localizer.string('Notifications',
               'message.combatLogInBuilding',
               [buildingAttackerId == ML.player.id
                    ? 'player'
                    : 'ally',
                location.planetName,
                fakeNpcBuilding.name
               ]
            );
      }
      
      public function get message() : String
      {
         return fakeNpcBuilding == null ? normalMessage : npcBuildingMessage;

      }
   }
}
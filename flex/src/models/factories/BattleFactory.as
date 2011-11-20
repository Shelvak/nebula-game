package models.factories
{
   import models.ModelLocator;
   import models.battle.BAlliance;
   import models.battle.BBuilding;
   import models.battle.BFlank;
   import models.battle.BPlayers;
   import models.battle.BUnit;
   import models.battle.Battle;
   import models.location.Location;
   
   import mx.collections.ArrayCollection;
   
   import utils.ArrayUtil;
   import utils.Objects;
   import utils.PropertiesTransformer;
   import utils.random.Rndm;
   
   public class BattleFactory
   {
      /**
       * Creates <code>Battle</code> model with all models and lists in it.
       * 
       * @param data Raw object containing all information about battle.
       *  
       * @return instance of <code>Battle</code>
       */
      public static function fromObject(data:Object, seed: uint) : Battle
      {
         data = PropertiesTransformer.objectToCamelCase(data);
         var battle:Battle = new Battle();
         battle.rand = new Rndm(seed);
         battle.logHash = data;
         battle.speed = data.speed == null?1:data.speed;
         
         // Create location
         battle.location = Objects.create(Location, data.location);
         
         var bAlliances: BPlayers = new BPlayers();
         bAlliances.clear();
         bAlliances.napRules = data.napRules;
         battle.allyNames = bAlliances;
         battle.unitsModelsHash = new Object();
         // Alliances
         var myId: int = ModelLocator.getInstance().player.id;
         battle.outcome = data.outcomes[myId];
         for (var allyKey: String in data.alliances)
         {
            var rawAlliance:Object = data.alliances[allyKey];
            bAlliances.addAlliance(rawAlliance.players, allyKey, rawAlliance.name, myId);
            var alliance:BAlliance = new BAlliance();
            alliance.addPlayers(bAlliances.getAlliance(allyKey));
            battle.alliances.addItem(alliance);
            // flanks in an aliance
            for each(var rawFlank:Object in ArrayUtil.fromObject(rawAlliance.flanks, true, true))
            {
               var flank:BFlank = new BFlank();
               alliance.flanks.addItem(flank);
               flank.flankNr = int(rawFlank.key);
               
               //space units
               for each (var spaceUnit: Object in rawFlank.prop.space)
               {
                  var sUnit: BUnit = Objects.create(BUnit, spaceUnit);
                  sUnit.hpActual = sUnit.hp;
                  sUnit.playerStatus = bAlliances.getPlayerStatus(myId, sUnit.playerId);
                  if (alliance.status == -1)
                  {
                     alliance.status = sUnit.playerStatus;
                  }
                  flank.spaceUnits.addItem(sUnit);
               }
               //ground units
               for each (var groundObject: Object in rawFlank.prop.ground)
               {
                  if (groundObject.kind == 0)
                  {
                     var gUnit: BUnit = Objects.create(BUnit, groundObject);
                     gUnit.hpActual = gUnit.hp;
                     gUnit.playerStatus = bAlliances.getPlayerStatus(myId, gUnit.playerId);
                     if (alliance.status == -1)
                     {
                        alliance.status = gUnit.playerStatus;
                     }
                     battle.unitsModelsHash[gUnit.id] = gUnit;
                     flank.groundUnits.addItem(gUnit);
                  }
                  else
                  {
                     var building: BBuilding = Objects.create(BBuilding, groundObject);
                     building.playerStatus = bAlliances.getPlayerStatus(myId, building.playerId);
                     if (alliance.status == -1)
                     {
                        alliance.status = building.playerStatus;
                     }
                     flank.buildings.addItem(building);
                  }
               }
            }
         }    
         battle.log = new ArrayCollection(data.log.ticks);
         battle.appearOrders = data.log.unloaded;
         battle.ticksTotal = battle.log.length;
         var groupOrders: int = 0;
         for each (var tick: Array in battle.log)
         {
            groupOrders += Math.ceil(tick.length/Battle.getGroupLength(tick.length));
         }
         battle.groupOrders = groupOrders;
         return battle;
      }
   }
}
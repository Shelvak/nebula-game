package models.factories
{
   import controllers.battle.BattleController;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.battle.BAlliance;
   import models.battle.BBuilding;
   import models.battle.BFlank;
   import models.battle.BPlayers;
   import models.battle.BUnit;
   import models.battle.BUnitKind;
   import models.battle.Battle;
   import models.location.Location;
   
   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;
   
   import utils.ArrayUtil;
   import utils.PropertiesTransformer;
   import utils.random.Rndm;
   
   public class BattleFactory
   {
      private static const APPEAR:String = "appear";
      private static const GROUP:String = "group";
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
         
         // Create location
         battle.location = BaseModel.createModel(Location, data.location);
         
         var bAlliances: BPlayers = new BPlayers();
         bAlliances.clear();
         bAlliances.napRules = data.napRules;
         // Alliances
         var myId: int = ModelLocator.getInstance().player.id;
         for (var allyKey: String in data.alliances)
         {
            var rawAlliance:Object = data.alliances[allyKey];
            bAlliances.addAlliance(rawAlliance.players, allyKey);
            var alliance:BAlliance = new BAlliance();
            battle.alliances.addItem(alliance);
            // flanks in an aliance
            for each(var rawFlank:Object in ArrayUtil.fromObject(rawAlliance.flanks, true, true))
            {
               var flank:BFlank = new BFlank();
               alliance.flanks.addItem(flank);
               flank.flankNr = int(rawFlank.key);
               
               // units in a flank
               for each (var rawObject:Object in rawFlank.prop)
               {
                  //UNIT
                  if (rawObject.kind == 0)
                  {
                  var nUnit: BUnit = BaseModel.createModel(BUnit, rawObject);
                  nUnit.playerStatus = bAlliances.getPlayerStatus(myId, nUnit.playerId);
                  if (alliance.status == -1)
                  {
                     alliance.status = nUnit.playerStatus;
                  }
                  flank.addUnit(nUnit, nUnit.kind);
                  }
                  //BUILDING
                  else
                  {
                     var building: BBuilding = BaseModel.createModel(BBuilding, rawObject);
                     building.playerStatus = bAlliances.getPlayerStatus(myId, building.playerId);
                     if (alliance.status == -1)
                     {
                        alliance.status = building.playerStatus;
                     }
                     battle.buildings.addItem(building);
                  }
               }
            }
         }
         
         //         //buildings TODO
         //         for each (var rawBuilding: Object in data.buildings)
         //         {
         //            var building: BBuilding = BaseModel.createModel(BBuilding, rawBuilding);
         //            battle.buildings.addItem(building);
         //         }
         //         
         battle.log = new ArrayCollection(data.log);
         
         for each (var order: Array in battle.log)
         if (order[0] == GROUP)
         {
            var groupOrder: Array = order[1];
            if (groupOrder[0] == APPEAR)
            {
               var aUnit: BUnit = BaseModel.createModel(BUnit, groupOrder[2]);
               aUnit.playerStatus = bAlliances.getPlayerStatus(myId, aUnit.playerId);
               //TODO battle.getFlankById( .addUnit(aUnit, BUnitKind.GROUND);
            }
         }
         
         return battle;
      }
   }
}
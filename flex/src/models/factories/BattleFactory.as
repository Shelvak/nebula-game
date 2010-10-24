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
   import models.battle.BattleParticipantType;
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
      private static const FIRE:String = "fire";
      /**
       * Creates <code>Battle</code> model with all models and lists in it.
       * 
       * @param data Raw object containing all information about battle.
       *  
       * @return instance of <code>Battle</code>
       */
      public static function fromObject(data:Object, seed: uint) : Battle
      {
         var hps: Object = {};
         data = PropertiesTransformer.objectToCamelCase(data);
         var battle:Battle = new Battle();
         battle.rand = new Rndm(seed);
         battle.outcome = data.outcomes;
         
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
            alliance.addPlayers(bAlliances.getAlliance(allyKey));
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
                     nUnit.actualHp = nUnit.hp;
                     hps[nUnit.id]=nUnit;
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
         battle.log = new ArrayCollection(data.log);
         var currentOrder: int = -1;
         for each (var order: Array in battle.log)
         {
            if (order[0] == GROUP)
            {
               var groupOrders: Array = order[1];
               /*
               #   log_item = [:appear, transporter_id, unit, flank_index]
               #     transporter_id - id of the transporter unit
               #     unit - Combat::Participant#as_json
               #     flank_index - Unit#flank
               */
               for each (var groupOrder: Array in groupOrders)
               {
                  currentOrder++;
                  if (groupOrder[0] == APPEAR)
                  {
                     var aUnit: BUnit = BaseModel.createModel(BUnit, groupOrder[2]);
                     aUnit.actualHp = aUnit.hp;
                     hps[aUnit.id]=aUnit;
                     aUnit.appearOrder = currentOrder;
                     aUnit.playerStatus = bAlliances.getPlayerStatus(myId, aUnit.playerId);
                     battle.addAppearingUnit(aUnit, groupOrder[3]);
                  }
                  else
                  {
                     if (groupOrder[0] == FIRE)
                     {
                        for each (var fireOrder: Object in groupOrder[2])
                        {
                           if (fireOrder[1][1] == BattleParticipantType.UNIT && !fireOrder[2])
                           {
                              var hitUnit: BUnit = hps[fireOrder[1][0]];
                              hitUnit.actualHp -= fireOrder[3];
                              if (hitUnit.actualHp <= 0)
                              {
                                 hitUnit.actualHp = hitUnit.hp;
                                 hitUnit.deathOrder = currentOrder;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         
         return battle;
      }
   }
}
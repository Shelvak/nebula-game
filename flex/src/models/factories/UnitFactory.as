package models.factories
{
   import models.ModelsCollection;
   import models.Owner;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.player.PlayerMinimal;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   import utils.Objects;
   import utils.StringUtil;


   /**
    * Lets easily create instances of units.
    */
   public class UnitFactory
   {
      /**
       * Creates a unit form a given simple object.
       *  
       * @param data An object representing a unit.
       * 
       * @return instance of <code>Unit</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : Unit {
         if (!data)
            throw new Error('Can not create unit, null given');
         return Objects.create(Unit, data);
      }
      
      /**
       * Each unit, which has <code>playerId</code> equal to <code>PlayerMinimal.NO_PLAYER_ID</code>, will
       * have <code>player</code> set to <code>NPC</code> player instance. If corresponding player object
       * can't be found in <code>playersHash</code> for any unit, error will be thrown.
       */
      public static function fromObjects(units:Array, playersHash:Object) : ModelsCollection {
         var players:Object = PlayerFactory.fromHash(playersHash);
         var source:Array = [];
         var errors:Array = [];
         for each (var unitData:Object in units) {
            var unit:Unit = fromObject(unitData);
            // TODO: move assignment of unit.player to afterCreateModel() method like in Location?
            if (unit.playerId == 0)
               unit.player = PlayerMinimal.NPC_PLAYER;
            else if (!players[unit.playerId])
               errors.push("No player for unit " + unit);
            else
               unit.player = players[unit.playerId];
            source.push(unit);
         }
         if (errors.length > 0)
            throw new Error(errors.join("\n"));
         return new ModelsCollection(source);
      }
      
      /**
       * Creates a list of <code>UnitBuildingEntry</code> from the given cached units generic object. 
       */
      public static function createCachedUnits(cachedUnits:Object) : ArrayCollection
      {
         var result:ArrayCollection = new ArrayCollection();
         for (var unitType:String in cachedUnits)
         {
            var entry:UnitBuildingEntry = new UnitBuildingEntry(
               "unit::" + StringUtil.underscoreToCamelCase(unitType),
               cachedUnits[unitType]
            );
            result.addItem(entry);
         }
         return result;
      }
      
      
      
      /**
       * 
       * @param source - list of Unit models
       * @return cached units
       * 
       */      
      public static function buildCachedUnitsFromUnits(source: IList): ArrayCollection
      {
         var types: Object = {};
         for each (var unit: Unit in source)
         {
            if (types[unit.type] == null)
            {
               types[unit.type] = 1;
            }
            else
            {
               types[unit.type] += 1;
            }
         }
         return createCachedUnits(types);
      }

      /**
       * Creates non-moving NPC units from special hash server sends with 
       * solar_systems|show.
       * 
       * It looks like this:
       *  {
       *    "location_x,location_y" => {
       *      "type,stance,flank,level" => [{"id" => int, "hp" => int}, ...]
       *    },
       *    ...
       *  }
       * 
       * @param npcUnits data hash
       * @param keys location keys to take from that hash
       * @param ssId solar system id
       * @return
       */
      public static function ssNpcUnits(
         npcUnits: Object, keys: Vector.<String>, ssId: int
      ): ModelsCollection {
         const unitsArr: Array = [];
         for each (var key: String in keys) {
            var splitKey: Array = key.split(",", 2);
            var locationX: int = int(splitKey[0]);
            var locationY: int = int(splitKey[1]);

            for (var groupKey: String in npcUnits[key]) {
               var splitGroup: Array = groupKey.split(",", 4);
               var type: String = splitGroup[0];
               var stance: int = int(splitGroup[1]);
               var flank: int = int(splitGroup[2]);
               var level: int = int(splitGroup[3]);
               
               for each (var data: Object in npcUnits[key][groupKey]) {
                  var unit: Unit = new Unit();
                  unit.id = data.id;
                  unit.hp = data.hp;
                  unit.type = type;
                  unit.stance = stance;
                  unit.flank = flank;
                  unit.level = level;
                  unit.location = new LocationMinimal(
                     LocationType.SOLAR_SYSTEM,
                     ssId,
                     locationX,
                     locationY
                  );
                  unit.player = PlayerMinimal.NPC_PLAYER;
                  unit.playerId = unit.player.id;
                  unit.owner = Owner.NPC;
                  unitsArr.push(unit);
               }
            }
         }
         return new ModelsCollection(unitsArr);
      }
   }
}
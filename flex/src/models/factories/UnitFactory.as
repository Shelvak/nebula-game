package models.factories
{
   import models.ModelsCollection;
   import models.player.PlayerId;
   import models.player.PlayerMinimal;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import utils.StringUtil;
   
   import utils.Objects;
   
   import utils.Objects;
   
   
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
            if (unit.playerId == PlayerId.NO_PLAYER)
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
   }
}
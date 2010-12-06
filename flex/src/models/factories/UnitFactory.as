package models.factories
{
   import flash.utils.getDefinitionByName;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.player.PlayerMinimal;
   import models.unit.Unit;
   
   import utils.Localizer;
   
   
   /**
    * Lets easily create instaces of units. 
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
      public static function fromObject(data:Object) : Unit
      {
         if (!data)
         {
            return null;
         }
         return BaseModel.createModel(Unit, data);
      }
      
      /**
       * Each unit, which has <code>playerId</code> equal to <code>PlayerMinimal.NO_PLAYER_ID</code>, will
       * have <code>player</code> set to <code>NPC</code> player instance. If corresponding player object
       * can't be found in <code>playersHash</code> for any unit, error will be thrown.
       */
      public static function fromObjects(units:Array, playersHash:Object) : ModelsCollection
      {
         var players:Object = PlayerFactory.fromHash(playersHash);
         var playerNpc:PlayerMinimal = new PlayerMinimal();
         playerNpc.name = Localizer.string("Players", "npc");
         var source:Array = [];
         var errors:Array = [];
         for each (var unitData:Object in units)
         {
            var unit:Unit = fromObject(unitData);
            if (unit.playerId == PlayerMinimal.NO_PLAYER_ID)
            {
               unit.player = playerNpc;
            }
            else if (!players[unit.playerId])
            {
               errors.push("No player for unit " + unit);
            }
            else
            {
               unit.player = players[unit.playerId];
            }
            source.push(unit);
         }
         if (errors.length > 0)
         {
            throw new Error(errors.join("\n"));
         }
         return new ModelsCollection(source);
      }
   }
}
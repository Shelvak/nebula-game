package models.factories
{
   import models.BaseModel;
   import models.player.PlayerMinimal;

   public class PlayerFactory
   {
      /**
       * Constructs a hash wich maps ids to instances of <code>PlayerMinimal</code>.
       */
      public static function fromHash(hash:Object) : Object
      {
         var playersHash:Object = new Object();
         for (var id:String in hash)
         {
            playersHash[id] = BaseModel.createModel(PlayerMinimal, hash[id]);
         }
         return playersHash;
      }
   }
}
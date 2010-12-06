package models.player
{
   import models.BaseModel;
   
   public class PlayerMinimal extends BaseModel
   {
      /**
       * If property <code>playerId</code> somewhere is set to this value (0) then that means that
       * the object does not belong to any player.
       */
      public static const NO_PLAYER_ID:int = 0;
      
      
      public function PlayerMinimal()
      {
         super();
      }
      
      
      [Bindable]
      [Optional]
      public var name:String = "";
   }
}
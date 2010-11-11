package models
{
   import mx.collections.ArrayCollection;
   
   [Bindable]
   public class Player extends BaseModel
   {
      /**
       * If property <code>playerId</code> somewhere is set to this value (-1) then that means that
       * the object does not belong to any player.
       */
      public static const NO_PLAYER_ID:int = -1;
      
      /**
       * If property <code>playerId</code> somewhere is set to this value (0) then that means that
       * the object does belong to a former player: a player who left the game before it has ended.
       */
      public static const FORMER_PLAYER_ID:int = 0;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * @default 0
       */
      public var galaxyId:int = 0;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * @default null
       */
      public var loggedIn:Boolean = false;
      
      
      /**
       * A list of all planets this player owns. Elements of this collection are instances of <b>SSObject</b>.
       */
      public var planets:ArrayCollection = new ArrayCollection();
      
      
      [Required]
      public var scientists:int = 0;
      
      [Required]
      public var scientistsTotal:int = 0;
      
      [Optional]
      public var name:String = "";
      
      [Optional]
      public var xp:int = 0;
      
      [Optional]
      public var allianceId:int = 0;
      
      [Optional]
      public var points:int = 0;
   }
}
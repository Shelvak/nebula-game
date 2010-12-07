package models.player
{
   import mx.collections.ArrayCollection;
   
   [Bindable]
   public class Player extends PlayerMinimal
   {
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</p>
       * 
       * @default 0
       */
      public var galaxyId:int = 0;
      
      
      [SkipProperty]
      /**
       * Makes sense only for the player instance in <code>ModelLocator</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</p>
       * 
       * @default null
       */
      public var loggedIn:Boolean = false;
      
      
      [SkipProperty]
      /**
       * A list of all planets this player owns. Elements of this collection are instances of <b>SSObject</b>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]</p>
       */
      public var planets:ArrayCollection = new ArrayCollection();
      
      
      [Optional]
      public var scientists:int = 0;
      
      [Optional]
      public var scientistsTotal:int = 0;
      
      [Optional]
      public var xp:int = 0;
      
      [Optional]
      public var allianceId:int = 0;
      
      [Optional]
      public var points:int = 0;
      
      public override function toString():String
      {
         return '[Player id: ' + id + ', name: ' + name + ', galaxyId: ' + galaxyId + ', scientists: ' + 
            scientists + ', scientistsTotal: ' + scientistsTotal + ', allianceId: ' + allianceId + ', xp: ' + 
            xp + ', points: ' + points + ', logged: ' + loggedIn + 
            ', planetsCount: ' + planets.length + ']'; 
      }
   }
}
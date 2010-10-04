package controllers.planets
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for downloading individual planets as well as list of solar system
    * planets.
    */
   public class PlanetsCommand extends CommunicationCommand
   {
      /**
       * Pushed by the server with a list of all planets that belong to the player.
       * 
       * @eventType planets|playerIndex
       */
      public static const PLAYER_INDEX:String = "planets|playerIndex";
      
      
      /**
       * @see controllers.planets.actions.ShowAction
       */ 
      public static const SHOW:String = "showPlanet";
      
      
      /**
       * Dispatch this to download planet list for a solar system and show it in the main area of the screen.
       * 
       * @eventType planetsIndex
       */ 
      public static const INDEX:String = "planetsIndex";
      
      
      
      
      /**
       * Constructor.
       */ 
      public function PlanetsCommand(type:String, parameters:Object = null, fromServer:Boolean = false)
      {
         super(type, parameters, fromServer);
      }
   }
}
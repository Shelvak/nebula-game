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
      public static const PLAYER_INDEX:String = "planets|player_index";
      
      
      /**
       * @see controllers.planets.actions.ShowAction
       */ 
      public static const SHOW:String = "planets|show";
      
      
      /**
       * Constructor.
       */ 
      public function PlanetsCommand(type:String, parameters:Object = null, fromServer:Boolean = false)
      {
         super(type, parameters, fromServer);
      }
   }
}
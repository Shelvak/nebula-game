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
       * @see controllers.planets.actions.TakeAction
       */ 
      public static const TAKE:String = "planets|take";
      
      /**
       * @see controllers.planets.action.ExploreAction
       */
      public static const EXPLORE:String = "planets|explore";
      
      /**
       * @see controllers.planets.actions.FinishExplorationAction
       */
      public static const FINISH_EXPLORATION:String = "planets|finish_exploration";
      
      /**
       * @see controllers.planets.actions.RemoveFoliageAction
       */
      public static const REMOVE_FOLIAGE:String = "planets|remove_foliage";
            
      /**
       * @see controllers.planets.actions.EditAction
       */
      public static const EDIT:String = "planets|edit";
      
      /**
       * @see controllers.planets.actions.BoostAction
       */
      public static const BOOST:String = "planets|boost";
      
      /**
       * @see controllers.planets.actions.PortalUnitsAction
       */
      public static const PORTAL_UNITS:String = "planets|portal_units";

      /**
       * @see controllers.planets.actions.BgSpawnAction
       */
      public static const BG_SPAWN: String = "planets|bg_spawn";

      /**
       * @see controllers.planets.actions.ReinitiateCombatAction
       */
      public static const REINITIATE_COMBAT: String = "planets|reinitiate_combat";


      public function PlanetsCommand(type: String,
                                     parameters: Object = null,
                                     fromServer: Boolean = false) {
         super(type, parameters, fromServer);
      }
   }
}
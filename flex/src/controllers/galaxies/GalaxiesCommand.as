package controllers.galaxies
{
   import controllers.CommunicationCommand;
   
   public class GalaxiesCommand extends CommunicationCommand
   {
      /**
       * @see controllers.galaxies.actions.ShowAction
       */
      public static const SHOW:String = "galaxies|show";

      /**
       * @see controllers.galaxies.actions.ApocalypseAction
       */
      public static const APOCALYPSE:String = "galaxies|apocalypse";

      /**
       * @see controllers.galaxies.actions.MapAction
       */
      public static const MAP: String = "galaxies|map";
      
      
      public function GalaxiesCommand(
         type: String, parameters: Object = null, fromServer: Boolean = false,
         eagerDispatch: Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}
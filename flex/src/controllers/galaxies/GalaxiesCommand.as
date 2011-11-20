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
       * @see controllers.galaxies.actions.ApocalypseStartAction
       */
      public static const APOCALYPSE_START:String = "galaxies|apocalypse_start";
      
      
      public function GalaxiesCommand(type:String,
                                      parameters:Object = null,
                                      fromServer:Boolean = false,
                                      eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}
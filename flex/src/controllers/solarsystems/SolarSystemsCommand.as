package controllers.solarsystems
{
   import controllers.CommunicationCommand;
   
   
   /**
    * Used for downloading solar system.
    */	
   public class SolarSystemsCommand extends CommunicationCommand
   {
      /**
       * @see controllers.solarsystems.actions.ShowAction
       */
      public static const SHOW:String = "solar_systems|show";
      
      
      /**
       * Constructor. 
       */
      public function SolarSystemsCommand(type:String,
                                          parameters:Object = null,
                                          fromServer:Boolean = false,
                                          eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}
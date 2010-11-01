package controllers.solarsystems
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for downloading solar systems.
    */	
   public class SolarSystemsCommand extends CommunicationCommand
   {
      /**
       * @see controllers.solarSystems.actions.IndexAction
       */      
      public static const INDEX: String = "solarSystemsIndex";
      
      
      
      
      /**
       * Constructor. 
       */
      public function SolarSystemsCommand
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}
package controllers.combatlogs
{
   import controllers.CommunicationCommand;
   
   /**
    * Used for retrieving log with id.
    */  
   public class CombatLogsCommand extends CommunicationCommand
   {
      public static const SHOW: String = "combat_logs|show";
      
      /**
       * Constructor. 
       */
      public function CombatLogsCommand
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}
package controllers.alliances
{
   import controllers.CommunicationCommand;
   
   
   public class AlliancesCommand extends CommunicationCommand
   {
      
      public static const RATINGS:String = "alliances|ratings";
      
      public static const NEW:String = "alliances|new";
      
      
      public function AlliancesCommand(type:String, parameters:Object = null, fromServer:Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}
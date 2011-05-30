package controllers.alliances
{
   import controllers.CommunicationCommand;
   
   
   public class AlliancesCommand extends CommunicationCommand
   {
      
      public static const RATINGS:String = "alliances|ratings";
      
      public static const NEW:String = "alliances|new";
      
      public static const SHOW:String = "alliances|show";
      
      public static const KICK:String = "alliances|kick";
      
      public static const LEAVE:String = "alliances|leave";
      
      public static const EDIT:String = "alliances|edit";
      
      public static const EDIT_DESCRIPTION:String = "alliances|edit_description";
      
      
      /**
       * @see controllers.alliances.actions.JoinAction
       */
      public static const JOIN:String = "alliances|join";
      
      
      /**
       * @see controllers.alliances.actions.InviteAction
       */
      public static const INVITE:String = "alliances|invite";
      
      
      public function AlliancesCommand(type:String, parameters:Object = null, fromServer:Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}
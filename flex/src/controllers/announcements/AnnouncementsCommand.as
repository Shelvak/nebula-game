package controllers.announcements
{
   import controllers.CommunicationCommand;
   
   import utils.remote.rmo.RemoteMessageObject;
   
   public class AnnouncementsCommand extends CommunicationCommand
   {
      /**
       * 
       */
      public static const NEW:String = "announcements|new";
      
      
      public function AnnouncementsCommand(type:String,
                                           parameters:Object = null,
                                           fromServer:Boolean = false,
                                           eagerDispatch:Boolean = false,
                                           rmo:RemoteMessageObject = null) {
         super(type, parameters, fromServer, eagerDispatch, rmo);
      }
   }
}
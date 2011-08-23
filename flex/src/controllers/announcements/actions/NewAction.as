package controllers.announcements.actions
{
   import components.announcement.AnnouncementPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.announcement.MAnnouncement;
   
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.ObjectUtil;
   
   import utils.DateUtil;
   import utils.Objects;
   
   
   /**
    * 
    */
   public class NewAction extends CommunicationAction
   {
      private function get logger() : ILogger {
         return Log.getLogger(Objects.getClassName(this, true));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         var params:Object = cmd.parameters;
         var announcement:MAnnouncement = MAnnouncement.getInstance();
         try {
            announcement.message = params["message"];
            announcement.event.occuresAt = DateUtil.parseServerDTF(params["endsAt"]);
            AnnouncementPopup.getInstance().show();
         }
         catch (err:TypeError) {
            logger.error(
               "Error while processing new announcement data:\n{0}\nError message: {1}",
               ObjectUtil.toString(params), err.message
            );
         }
      }
   }
}
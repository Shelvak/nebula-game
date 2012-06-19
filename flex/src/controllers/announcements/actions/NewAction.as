package controllers.announcements.actions
{
   import components.announcement.AnnouncementPopup;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.announcement.MAnnouncement;

   import mx.utils.ObjectUtil;

   import utils.DateUtil;
   import utils.logging.Log;


   public class NewAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         var params:Object = cmd.parameters;
         var announcement:MAnnouncement = MAnnouncement.getInstance();
         try {
            announcement.message = params["message"];
            announcement.event.occursAt = DateUtil.parseServerDTF(params["endsAt"]);
            AnnouncementPopup.getInstance().show();
         }
         catch (err:Error) {
            Log.getMethodLogger(this, "applyServerAction").error(
               "Error while processing new announcement data:\n{0}\nError message: {1}",
               ObjectUtil.toString(params), err.message
            );
         }
      }
   }
}
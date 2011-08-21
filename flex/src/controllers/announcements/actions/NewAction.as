package controllers.announcements.actions
{
   import components.announcement.AnnouncementPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.announcement.MAnnouncement;
   
   import utils.DateUtil;
   
   /**
    * 
    */
   public class NewAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         var params:Object = cmd.parameters;
         var announcement:MAnnouncement = MAnnouncement.getInstance();
         announcement.message = params["message"];
         announcement.event.occuresAt = DateUtil.parseServerDTF(params["endsAt"]);
         AnnouncementPopup.getInstance().show();
      }
   }
}
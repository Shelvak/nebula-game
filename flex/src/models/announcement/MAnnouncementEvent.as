package models.announcement
{
   import flash.events.Event;
   
   public class MAnnouncementEvent extends Event
   {
      /**
       * Dispatched when <code>MAnnouncement.buttonVisible</code> property changes.
       * @eventType buttonVisibleChange
       */
      public static const BUTTON_VISIBLE_CHANGE:String = "buttonVisibleChange";
      
      /**
       * Dispatched when <code>MAnnouncement</code> has been reset.
       * @eventType reset
       */
      public static const RESET:String = "reset";
      
      public function MAnnouncementEvent(type:String) {
         super(type);
      }
   }
}
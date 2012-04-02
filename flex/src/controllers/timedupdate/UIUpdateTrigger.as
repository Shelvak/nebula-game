package controllers.timedupdate
{
   import models.announcement.MAnnouncement;
   import models.chat.MChat;


   /**
    * Place for updating IUpdatable in UI requiring little CPU time like
    * announcement or chat timers.
    */
   public class UIUpdateTrigger implements IUpdateTrigger
   {
      private function get chat(): MChat {
         return MChat.getInstance();
      }

      private function get announcement(): MAnnouncement {
         return MAnnouncement.getInstance();
      }

      public function update(): void {
         chat.update();
         announcement.update();
      }

      public function resetChangeFlags(): void {
         chat.resetChangeFlags();
         announcement.resetChangeFlags();
      }
   }
}

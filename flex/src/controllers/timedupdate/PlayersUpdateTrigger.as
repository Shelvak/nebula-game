package controllers.timedupdate
{
   import interfaces.IUpdatable;
   
   import models.ModelLocator;
   import models.announcement.MAnnouncement;
   import models.chat.MChat;
   import models.galaxy.Galaxy;


   public class PlayersUpdateTrigger implements IUpdateTrigger
   {
      private function get galaxy(): Galaxy {
         return ModelLocator.getInstance().latestGalaxy;
      }

      private function get chat():MChat {
         return MChat.getInstance();
      }

      private var _thePlayer:IUpdatable;
      // TODO: Move to another trigger (perhaps special trigger for small and lonely models?)
      private var _announcement:IUpdatable;
      
      public function PlayersUpdateTrigger() {
         _thePlayer = ModelLocator.getInstance().player;
         _announcement = MAnnouncement.getInstance();
      }
      
      public function update() : void {
         _thePlayer.update();
         _announcement.update();
         chat.update();
         if (galaxy != null) {
            galaxy.update();
         }
      }
      
      public function resetChangeFlags() : void {
         _thePlayer.resetChangeFlags();
         _announcement.resetChangeFlags();
         chat.resetChangeFlags();
         if (galaxy != null) {
            galaxy.resetChangeFlags();
         }
      }
   }
}
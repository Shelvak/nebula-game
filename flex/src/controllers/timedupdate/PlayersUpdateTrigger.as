package controllers.timedupdate
{
   import interfaces.IUpdatable;
   
   import models.ModelLocator;
   import models.announcement.MAnnouncement;
   
   
   public class PlayersUpdateTrigger implements IUpdateTrigger
   {
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
         ModelLocator.getInstance().latestGalaxy.update();
      }
      
      public function resetChangeFlags() : void {
         _thePlayer.resetChangeFlags();
         _announcement.resetChangeFlags();
         ModelLocator.getInstance().latestGalaxy.resetChangeFlags();
      }
   }
}
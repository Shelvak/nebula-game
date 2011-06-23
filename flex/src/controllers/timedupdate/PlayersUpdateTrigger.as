package controllers.timedupdate
{
   import interfaces.IUpdatable;
   
   import models.ModelLocator;
   
   
   public class PlayersUpdateTrigger implements IUpdateTrigger
   {
      private var _thePlayer:IUpdatable;
      
      
      public function PlayersUpdateTrigger()
      {
         _thePlayer = ModelLocator.getInstance().player;
      }
      
      
      public function update() : void
      {
         _thePlayer.update();
      }
      
      
      public function resetChangeFlags() : void
      {
         _thePlayer.resetChangeFlags();
      }
   }
}
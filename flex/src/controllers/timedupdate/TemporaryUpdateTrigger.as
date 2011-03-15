package controllers.timedupdate
{
   import models.IMSelfUpdating;
   
   
   public class TemporaryUpdateTrigger implements IUpdateTriggerTemporary
   {
      public function TemporaryUpdateTrigger()
      {
      }
      
      
      public function registerModel(model:IMSelfUpdating) : void
      {
      }
      
      
      public function unregisterModel(model:IMSelfUpdating) : void
      {
      }
      
      
      public function update() : void
      {
      }
      
      
      public function resetChangeFlags() : void
      {
      }
   }
}
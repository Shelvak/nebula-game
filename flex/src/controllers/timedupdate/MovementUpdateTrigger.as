package controllers.timedupdate
{
   import models.ModelLocator;
   
   public class MovementUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function MovementUpdateTrigger() {
      }
      
      
      public function update() : void {
         MasterUpdateTrigger.update(ML.routes);
         MasterUpdateTrigger.update(ML.squadrons);
      }
      
      public function resetChangeFlags() : void {
         MasterUpdateTrigger.resetChangeFlags(ML.routes);
         MasterUpdateTrigger.resetChangeFlags(ML.squadrons);
      }
   }
}
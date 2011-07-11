package controllers.timedupdate
{
   import models.ModelLocator;
   import models.movement.MRoute;
   
   
   public class MovementUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function MovementUpdateTrigger() {
      }
      
      
      public function update() : void {
         for each (var route:MRoute in ML.routes) {
            route.update();
         }
      }
      
      public function resetChangeFlags() : void {
         for each (var route:MRoute in ML.routes) {
            route.resetChangeFlags();
         }
      }
   }
}
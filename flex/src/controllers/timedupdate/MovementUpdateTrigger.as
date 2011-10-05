package controllers.timedupdate
{
   import models.ModelLocator;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   
   
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
         // since there are no hostiles routes in ML.routes, we have to update
         // squadron in a planet directly so that jumpsAt time would be updated
         if (ML.latestPlanet != null) {            
            for each (var squad:MSquadron in ML.latestPlanet.squadrons) {
               squad.update();
            }
         }
      }
      
      public function resetChangeFlags() : void {
         for each (var route:MRoute in ML.routes) {
            route.resetChangeFlags();
         }
         if (ML.latestPlanet != null) {            
            for each (var squad:MSquadron in ML.latestPlanet.squadrons) {
               squad.resetChangeFlags();
            }
         }
      }
   }
}
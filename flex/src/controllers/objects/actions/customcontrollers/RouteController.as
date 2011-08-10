package controllers.objects.actions.customcontrollers
{
   import controllers.units.SquadronsController;
   
   
   public class RouteController extends BaseObjectController
   {
      /**
       * This reason is sent by the server if units have arrived at their destination and should be
       * stopped there.
       */ 
      private static const DESTR_REASON_COMPLETED:String = "completed";
      
      
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      
      public function RouteController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         SQUADS_CTRL.updateRoute(object);
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         SQUADS_CTRL.stopSquadron(objectId, reason == DESTR_REASON_COMPLETED);
      }
   }
}
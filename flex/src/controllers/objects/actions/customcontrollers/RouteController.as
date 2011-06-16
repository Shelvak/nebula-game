package controllers.objects.actions.customcontrollers
{
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import models.BaseModel;
   import models.location.Location;
   
   import utils.SingletonFactory;
   
   
   public class RouteController extends BaseObjectController
   {
      public static function getInstance() : RouteController
      {
         return SingletonFactory.getSingletonInstance(RouteController);
      }
      
      
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      /**
       * This reason is sent by the server if units have arrived at their destination and should be
       * stopped there.
       */ 
      private static const DESTR_REASON_COMPLETED:String = "completed";
      
      
      public function RouteController()
      {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         SQUADS_CTRL.updateRoute(object);
      }
      
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void
      {
         SQUADS_CTRL.stopSquadron(objectId, reason == DESTR_REASON_COMPLETED);
      }
   }
}
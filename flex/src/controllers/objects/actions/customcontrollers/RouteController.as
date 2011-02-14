package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import models.BaseModel;
   import models.location.Location;
   
   
   public class RouteController extends BaseObjectController
   {
      public static function getInstance() : RouteController
      {
         return SingletonFactory.getSingletonInstance(RouteController);
      }
      
      
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
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
         SQUADS_CTRL.stopSquadron(objectId);
      }
   }
}
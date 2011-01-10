package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.objects.UpdatedReason;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import models.factories.UnitFactory;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   
   
   public class UnitController extends BaseObjectController
   {
      public static function getInstance() : UnitController
      {
         return SingletonFactory.getSingletonInstance(UnitController);
      }
      
      
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      public function UnitController()
      {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         var unit:Unit = UnitFactory.fromObject(object);
         unit.player = ML.player;
         if (unit.lastUpdate != null)
         {
            unit.upgradePart.startUpgrade();
         }
         ML.units.addItem(unit);
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         var unit:Unit = UnitFactory.fromObject(object);
         if (reason == UpdatedReason.COMBAT)
         {
            ML.units.addOrUpdate(unit);  
         }
         else
         {
            ML.units.update(unit);
         }
      }
      
      
      public function unitsDestroyed(unitIds:Array, reason:String) : void
      {
         var destroyedUnits:ArrayCollection = ML.units.removeWithIDs(unitIds, reason == UpdatedReason.COMBAT);
         SQUADS_CTRL.destroyEmptySquadrons(destroyedUnits);
         ORDERS_CTRL.cancelOrderIfInvolves(destroyedUnits);
      }
   }
}
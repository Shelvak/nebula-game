package controllers.objects.actions.customcontrollers
{
   import controllers.objects.UpdatedReason;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import models.factories.UnitFactory;
   import models.player.PlayerId;
   import models.player.PlayerMinimal;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   
   import utils.SingletonFactory;
   import utils.locale.Localizer;
   
   
   public class UnitController extends BaseObjectController
   {
      public static function getInstance() : UnitController {
         return SingletonFactory.getSingletonInstance(UnitController);
      }
      
      private const NPC_PLAYER:PlayerMinimal = new PlayerMinimal();
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      public function UnitController() {
         super();
         NPC_PLAYER.name = Localizer.string("Players", "npc");
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : * {
         var unit:Unit = UnitFactory.fromObject(object);
         if (unit.playerId == PlayerId.NO_PLAYER)
            unit.player = NPC_PLAYER;
         else if (unit.playerId == ML.player.id)
            unit.player = ML.player;
         if (unit.level == 0)
            unit.upgradePart.startUpgrade();
         ML.units.addItem(unit);
         return unit;
      }
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var unit:Unit = UnitFactory.fromObject(object);
         if (reason == UpdatedReason.COMBAT ||
             reason == UpdatedReason.TRANSPORTATION) {
            if (!ML.units.addOrUpdate(unit))
               unit.cleanup();
         }
         else {
            ML.units.update(unit);
            unit.cleanup();
         }
      }
      
      public function unitsDestroyed(unitIds:Array, reason:String) : void {
         var destroyedUnits:ArrayCollection = ML.units.removeWithIDs(unitIds, reason == UpdatedReason.COMBAT);
         SQUADS_CTRL.destroyEmptySquadrons(destroyedUnits);
         ORDERS_CTRL.cancelOrderIfInvolves(destroyedUnits);
      }
   }
}
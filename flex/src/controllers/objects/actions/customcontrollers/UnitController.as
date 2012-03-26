package controllers.objects.actions.customcontrollers
{
   import controllers.objects.UpdatedReason;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   import controllers.units.UnitJumps;

   import models.factories.UnitFactory;
   import models.location.LocationType;
   import models.player.PlayerMinimal;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;

   import utils.Objects;

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


      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         var unit: Unit = UnitFactory.fromObject(object);
         if (unit.playerId == 0) {
            unit.player = NPC_PLAYER;
         }
         else if (unit.playerId == ML.player.id) {
            unit.player = ML.player;
         }
         if (unit.level == 0) {
            unit.upgradePart.startUpgrade();
         }
         ML.units.addItem(unit);
         return unit;
      }

      public override function objectUpdated(objectSubclass: String,
                                             object: Object,
                                             reason: String): void {
         const locData: Object = object["location"];
         const locString: String = UnitJumps.buildLocationString(
            locData["type"], locData["id"], locData["x"], locData["y"]
         );
         if (UnitJumps.preJumpLocationMatches(object["id"], locString)) {
            return;
         }
         if (reason == UpdatedReason.TRANSPORTATION) {
            if (object.location.type == LocationType.UNIT)
            {
               ML.units.remove(object.id);
            }
            else
            {
               ML.units.addOrUpdate(object, Unit);
            }
         }
         else if (reason == UpdatedReason.COMBAT) {
            const existingUnit: Unit = ML.units.find(object["id"]);
            if (existingUnit != null) {
               existingUnit.hp = object["hp"];
               existingUnit.level = object["level"];
               existingUnit.xp = object["xp"];
               existingUnit.owner = object["status"];
               existingUnit.stored = object["stored"];
            }
            else {
               ML.units.addItem(Objects.create(Unit, object));
            }
         }
         else {
            ML.units.update(object);
         }
      }

      public function unitsDestroyed(unitIds: Array, reason: String): void {
         const destroyedUnits: ArrayCollection =
                  ML.units.removeWithIDs(unitIds, true);
         SQUADS_CTRL.destroyEmptySquadrons(destroyedUnits);
         ORDERS_CTRL.cancelOrderIfInvolves(destroyedUnits);
      }
   }
}
/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/27/12
 * Time: 1:14 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.objects.actions.customcontrollers
{
   import controllers.objects.UpdatedReason;
   import controllers.startup.StartupInfo;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;

   import models.factories.TechnologyFactory;

   import models.factories.UnitFactory;
   import models.parts.TechnologyUpgradable;
   import models.player.PlayerMinimal;
   import models.technology.TechnologiesModel;
   import models.technology.Technology;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;

   import utils.Objects;

   import utils.SingletonFactory;
   import utils.locale.Localizer;
   import utils.logging.Log;


   public final class TechnologyController extends BaseObjectController
   {
      public static function getInstance() : TechnologyController {
         return SingletonFactory.getSingletonInstance(TechnologyController);
      }


      public function TechnologyController() {
         super();
      }


      public override function objectCreated(
         objectSubclass: String, object: Object, reason: String): *
      {
         objectUpdated(objectSubclass, object,  reason);
      }

      public override function objectUpdated(
         objectSubclass: String, object: Object, reason: String): void
      {
         const technologies: TechnologiesModel = ML.technologies;
         if (StartupInfo.relaxedServerMessagesHandlingMode && !technologies.initialized) {
            Log.getMethodLogger(this, "objectUpdated").warn(
               "Server wants to update technology {0} before sending technologies|index. Ignoring.",
               ObjectUtil.toString(object));
            return;
         }
         var technology: Technology = technologies.getTechnologyByType(object.type);
         technology.upgradePart.stopUpgrade();
         Objects.update(technology, object);
         if (technology.upgradeEndsAt != null)
         {
            technology.upgradePart.startUpgrade();
         }
         else
         {
            TechnologyUpgradable(technology.upgradePart).dispatchUpgradeFinishedEvent();
            ML.resourcesMods.recalculateMods();
            technologies.dispatchTechsChangeEvent();
         }
      }


      override public function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         ML.technologies.getTechnologyById(objectId).level = 0;
         ML.technologies.dispatchTechsChangeEvent();
      }
   }
}

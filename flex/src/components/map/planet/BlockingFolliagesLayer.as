package components.map.planet
{
   import components.map.planet.objects.BlockingFolliageMapObject;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import controllers.navigation.MCSidebar;
   import controllers.notifications.EventsController;
   import controllers.screens.SidebarScreens;

   import models.ModelLocator;
   import models.exploration.ExplorationStatus;
   import models.folliage.BlockingFolliage;
   import models.notification.MPermanentEvent;

   import mx.collections.ListCollectionView;

   import utils.locale.Localizer;


   public class BlockingFolliagesLayer extends PlanetVirtualLayer
   {
      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      override protected function get componentClass(): Class {
         return BlockingFolliageMapObject;
      }

      override protected function get modelClass(): Class {
         return BlockingFolliage;
      }

      override protected function get objectsList(): ListCollectionView {
         return planet.blockingFolliages;
      }

      private function get SD(): MCSidebar {
         return MCSidebar.getInstance();
      }


      /* ####################################### */
      /* ### FOLIAGE SELECTION / DESELECTION ### */
      /* ####################################### */

      private var eventPopUpId: int;

      protected override function objectSelectedImpl(object: IInteractivePlanetMapObject): void {
         ML.selectedFoliage = BlockingFolliage(object.model);
         eventPopUpId = new MPermanentEvent(Localizer.string('BuildingSelectedSidebar',
            'message.pressOnEmpty')).id;
         SD.showScreen(SidebarScreens.BLOCKING_FOLLIAGE);
      }

      protected override function objectDeselectedImpl(object: IInteractivePlanetMapObject): void {
         ML.selectedFoliage = null;
         EventsController.getInstance().removeEventById(eventPopUpId);
         SD.showPrevious();
      }

      protected override function openObjectImpl(object: IPrimitivePlanetMapObject): void {
         ExplorationStatus.getInstance().beginExploration();
      }
   }
}
package components.map.planet
{
   
   import components.map.planet.objects.BlockingFolliageMapObject;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   
   import controllers.Messenger;
   import controllers.navigation.MCSidebar;
   import controllers.screens.SidebarScreens;
   
   import models.ModelLocator;
   import models.exploration.ExplorationStatus;
   import models.folliage.BlockingFolliage;
   
   import utils.locale.Localizer;
   
   
   public class BlockingFolliagesLayer extends PlanetVirtualLayer
   {
      private var ML:ModelLocator = ModelLocator.getInstance();
      
      
      override protected function get componentClass() : Class
      {
         return BlockingFolliageMapObject;
      }
      
      
      override protected function get modelClass() : Class
      {
         return BlockingFolliage;
      }
      
      
      override protected function get objectsListName() : String
      {
         return "blockingFolliages";
      }
      
      private function get SD(): MCSidebar
      {
         return MCSidebar.getInstance();
      }
      
      /* ######################################### */
      /* ### FOLLIAGES SELECTION / DESELECTION ### */
      /* ######################################### */
      
      
      protected override function objectSelectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedFoliage = BlockingFolliage(object.model);
         Messenger.show(Localizer.string('BuildingSelectedSidebar', 'message.pressOnEmpty'));
         SD.showScreen(SidebarScreens.BLOCKING_FOLLIAGE);
      }
      
      
      protected override function objectDeselectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedFoliage = null;
         Messenger.hide();
         SD.showPrevious();
      }
      
      
      protected override function openObjectImpl(object:IPrimitivePlanetMapObject):void
      {
         ExplorationStatus.getInstance().beginExploration();
      }
   }
}
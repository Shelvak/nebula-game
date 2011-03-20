package components.map.planet
{
   
   import controllers.Messenger;
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import models.ModelLocator;
   import models.exploration.ExplorationStatus;
   import models.folliage.BlockingFolliage;
   
   import utils.locale.Localizer;
   import components.map.planet.objects.BlockingFolliageMapObject;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   
   
   public class BlockingFolliagesLayer extends PlanetVirtualLayer
   {
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var SSS:SidebarScreensSwitch = SidebarScreensSwitch.getInstance();
      
      
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
      
      
      /* ######################################### */
      /* ### FOLLIAGES SELECTION / DESELECTION ### */
      /* ######################################### */
      
      
      protected override function objectSelectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedFolliage = BlockingFolliage(object.model);
         Messenger.show(Localizer.string('BuildingSelectedSidebar', 'message.pressOnEmpty'));
         SSS.showScreen(SidebarScreens.BLOCKING_FOLLIAGE);
      }
      
      
      protected override function objectDeselectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedFolliage = null;
         Messenger.hide();
         SSS.showPrevious();
      }
      
      
      protected override function openObjectImpl(object:IPrimitivePlanetMapObject):void
      {
         ExplorationStatus.getInstance().beginExploration();
      }
   }
}
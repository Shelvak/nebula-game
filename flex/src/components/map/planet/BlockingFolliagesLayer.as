package components.map.planet
{
   import components.gameobjects.planet.BlockingFolliageMapObject;
   import components.gameobjects.planet.IInteractivePlanetMapObject;
   
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import models.ModelLocator;
   import models.folliage.BlockingFolliage;
   
   
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
         SSS.showScreen(SidebarScreens.BLOCKING_FOLLIAGE);
      }
      
      
      protected override function objectDeselectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedBuilding = null;
         SSS.showPrevious();
      }
   }
}
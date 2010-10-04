package components.gameobjects.solarsystem
{
   import components.base.BaseSkinnableContainer;
   import components.map.space.IMapSpaceObject;
   
   import controllers.ui.NavigationController;
   
   import flash.events.MouseEvent;
   
   import models.location.LocationMinimal;
   import models.solarsystem.SolarSystem;
   
   
   public class SolarSystemTile extends BaseSkinnableContainer implements IMapSpaceObject
   {
      /**
       * Width of solar system tile in a map in pixels.
       */
      public static const WIDTH: Number = 96;
      
      /**
       * Height of solar system tile in a map in pixels.
       */ 
      public static const HEIGHT: Number = WIDTH;
      
      
      public function SolarSystemTile()
      {
         super();
         width = WIDTH;
         height = HEIGHT;
         addSelfEventHandlers();
      }
      
      
      /**
       * @return typed reference to <code>model</code>
       */
      public function getModel() : SolarSystem
      {
         return SolarSystem(model);
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return getModel().currentLocation;
      }
      
      
      /**
       * Navigates to this planet.
       */
      public function select() : void
      {
         NavigationController.getInstance().toSolarSystem(getModel().id);
      }
      
      
      /* ############################ */
      /* ### SLEFT EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.CLICK, this_clickHandler);
      }
      
      
      private function this_clickHandler(event:MouseEvent) : void
      {
         select();
      }
   }
}

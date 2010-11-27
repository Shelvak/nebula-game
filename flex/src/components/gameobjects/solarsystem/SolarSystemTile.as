package components.gameobjects.solarsystem
{
   import components.base.BaseSkinnableContainer;
   import components.gameobjects.skins.SolarSystemTileSkin;
   import components.map.space.IMapSpaceObject;
   
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
         setStyle("skinClass", SolarSystemTileSkin);
      }
      
      
      /**
       * @return typed reference to <code>model</code>
       */
      public function getModel() : SolarSystem
      {
         return SolarSystem(model);
      }
      
      
      public function get locationCurrent() : LocationMinimal
      {
         return getModel().currentLocation;
      }

   }
}

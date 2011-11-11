package components.factories
{
   import components.base.viewport.ViewportZoomable;
   import components.base.viewport.VisibleAreaTracker;
   import components.battle.BattleMap;
   import components.map.CMap;
   import components.map.controllers.GalaxyViewportController;
   import components.map.controllers.IMapViewportController;
   import components.map.controllers.SolarSystemViewportController;
   import components.map.controllers.ViewportZoomController;
   import components.map.planet.PlanetMap;
   import components.map.space.CMapGalaxy;
   import components.map.space.CMapSolarSystem;
   import components.map.space.GalaxyMapCoordsTransform;
   
   import flash.display.BitmapData;
   
   import models.battle.Battle;
   import models.galaxy.Galaxy;
   import models.galaxy.VisibleGalaxyArea;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.MPlanet;
   import models.solarsystem.MSolarSystem;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Lets easily create different type maps. 
    */   
   public class MapFactory
   {
      private static function getImage(name:String) : BitmapData {
         return ImagePreloader.getInstance().getImage(name);
      }
      
      
      /* ########### */
      /* ### MAP ### */
      /* ########### */
      
      
      private static const MAP_FACTORY_METHODS:Object = new Object();
      MAP_FACTORY_METHODS[MapType.GALAXY] = function(g:Galaxy) : CMap {
         return new CMapGalaxy(g);
      };
      MAP_FACTORY_METHODS[MapType.PLANET] = function(p:MPlanet) : CMap {
         return new PlanetMap(p);
      };
      MAP_FACTORY_METHODS[MapType.BATTLE] = function(b:Battle) : CMap {
         return new BattleMap(b);
      };
      MAP_FACTORY_METHODS[MapType.SOLAR_SYSTEM] = function(ss:MSolarSystem) : CMap {
         return new CMapSolarSystem(ss);
      };
      
      
      private static function getMap(model:MMap) : CMap {
         return (MAP_FACTORY_METHODS[model.mapType] as Function).call(null, model);
      }
      
      
      private static const VIEWPORT_FACTORY_METHODS:Object = new Object();
      VIEWPORT_FACTORY_METHODS[MapType.GALAXY] = function(map:CMapGalaxy) : ViewportZoomable {
         var galaxy:Galaxy = map.getGalaxy();
         var viewport:ViewportZoomable = new ViewportZoomable(
            new VisibleAreaTracker(
               new VisibleGalaxyArea(
                  galaxy, map,
                  new GalaxyMapCoordsTransform(galaxy)
               )
            )
         );
         viewport.underlayImage = getImage(AssetNames.getSpaceBackgroundImageName());
         viewport.underlayScrollSpeedRatio = 0.07;
         viewport.paddingHorizontal = 50;
         viewport.paddingVertical   = 50;
         return viewport;
      };
      VIEWPORT_FACTORY_METHODS[MapType.SOLAR_SYSTEM] = function(map:CMapSolarSystem) : ViewportZoomable {
         var viewport:ViewportZoomable = new ViewportZoomable();
         viewport.underlayImage = getImage(AssetNames.getSpaceBackgroundImageName());
         viewport.underlayScrollSpeedRatio = 0.07;
         viewport.paddingHorizontal = 300;
         viewport.paddingVertical = 300;
         return viewport;
      };
      VIEWPORT_FACTORY_METHODS[MapType.PLANET] = function(map:PlanetMap) : ViewportZoomable {
         var viewport:ViewportZoomable = new ViewportZoomable();
         viewport.paddingHorizontal = 50;
         viewport.paddingVertical   = 50;
         return viewport;
      };
      VIEWPORT_FACTORY_METHODS[MapType.BATTLE] = function(map:BattleMap) : ViewportZoomable {
         var viewport:ViewportZoomable = new ViewportZoomable();
         viewport.paddingHorizontal = 50;
         viewport.paddingVertical   = 50;
         return viewport;
      };
      
      
      private static function getViewport(model:MMap, map:CMap) : ViewportZoomable {
         return (VIEWPORT_FACTORY_METHODS[model.mapType] as Function).call(null, map);
      }
      
      
      /* ######################### */
      /* ### VIEWPORT WITH MAP ### */
      /* ######################### */
      
      
      /**
       * Creates and returns <code>ViewportZoomable</code> with map set.
       * 
       * @param model model of a map to create map component and then viewport component for.
       *  
       * @return ready to use isntance of <code>ViewportZoomable</code>
       */
      public static function getViewportWithMap(model:MMap) : ViewportZoomable {
         var map:CMap = getMap(model);
         var viewport:ViewportZoomable = getViewport(model, map);
         map.viewport = viewport;
         viewport.left = 0;
         viewport.right = 0;
         viewport.top = 0;
         viewport.bottom  = 0;
         viewport.content = map;
         return viewport;
      }
      
      
      /* ########################################### */
      /* ### VIEWPORT CONTROLLERS FACTORY METHOD ### */
      /* ########################################### */
      
      
      private static const VIEWPORT_CONTROLLERS:Object = new Object();
      VIEWPORT_CONTROLLERS[MapType.GALAXY] = GalaxyViewportController;
      VIEWPORT_CONTROLLERS[MapType.PLANET] = ViewportZoomController;
      VIEWPORT_CONTROLLERS[MapType.BATTLE] = null;
      VIEWPORT_CONTROLLERS[MapType.SOLAR_SYSTEM] = SolarSystemViewportController;
      
      
      /**
       * Creates and returns instance of specific implementation of <code>IMapViewportController</code>
       * for a given map.
       * 
       * @param model a map to create controller for
       * 
       * @return instance of specific implementation of <code>IMapViewportController</code>
       * suitable for a given map 
       */
      public static function getViewportController(model:MMap) : IMapViewportController {
         if (VIEWPORT_CONTROLLERS[model.mapType] != null) {
            var controller:IMapViewportController = new (Class(VIEWPORT_CONTROLLERS[model.mapType]))();
            controller.left = 0;
            controller.right = 0;
            controller.top = 0;
            controller.bottom = 0;
            return controller;
         }
         else {
            return null;
         }
      }
   }
}
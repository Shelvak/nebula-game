package components.factories
{
   import components.base.viewport.ViewportZoomable;
   import components.battle.BattleMap;
   import components.map.CMap;
   import components.map.controllers.GalaxyViewportController;
   import components.map.controllers.IMapViewportController;
   import components.map.controllers.SolarSystemViewportController;
   import components.map.controllers.ViewportZoomController;
   import components.map.planet.PlanetMap;
   import components.map.space.CMapGalaxy;
   import components.map.space.CMapSolarSystem;
   
   import flash.display.BitmapData;
   
   import models.battle.Battle;
   import models.galaxy.Galaxy;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.Planet;
   import models.solarsystem.SolarSystem;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Lets easily create different type maps. 
    */   
   public class MapFactory
   {
      private static function getImage(name:String) : BitmapData
      {
         return ImagePreloader.getInstance().getImage(name);
      }
      
      
      /* ########### */
      /* ### MAP ### */
      /* ########### */
      
      
      private static const MAP_FACTORY_METHODS:Object = new Object();
      with (MapType)
      {
         MAP_FACTORY_METHODS[GALAXY] = function(g:Galaxy) : CMap
         {
            return new CMapGalaxy(g);
         };
         MAP_FACTORY_METHODS[PLANET] = function(p:Planet) : CMap
         {
            return new PlanetMap(p);
         };
         MAP_FACTORY_METHODS[BATTLE] = function(b:Battle) : CMap
         {
            return new BattleMap(b);
         };
         MAP_FACTORY_METHODS[SOLAR_SYSTEM] = function(ss:SolarSystem) : CMap
         {
            return new CMapSolarSystem(ss);
         };
      };
      
      
      private static function getMap(model:MMap) : CMap
      {
         return (MAP_FACTORY_METHODS[model.mapType] as Function).call(null, model);
      }
      
      
      private static const VIEWPORT_FACTORY_METHODS:Object = new Object();
      with (MapType)
      {
         VIEWPORT_FACTORY_METHODS[GALAXY] = function() : ViewportZoomable
         {
            var viewport:ViewportZoomable = new ViewportZoomable();
            with (viewport)
            {
               underlayImage = getImage(AssetNames.getSpaceBackgroundImageName());
               underlayScrollSpeedRatio = 0.2;
               viewport.paddingHorizontal = 50;
               viewport.paddingVertical   = 50;
            }
            return viewport;
         };
         VIEWPORT_FACTORY_METHODS[SOLAR_SYSTEM] = function() : ViewportZoomable
         {
            var viewport:ViewportZoomable = new ViewportZoomable();
            with (viewport)
            {
               underlayImage = getImage(AssetNames.getSpaceBackgroundImageName());
               underlayScrollSpeedRatio = 0.2;
               paddingHorizontal = 300;
               paddingVertical = 300;
            }
            return viewport;
         };
         VIEWPORT_FACTORY_METHODS[PLANET] = function() : ViewportZoomable
         {
            var viewport:ViewportZoomable = new ViewportZoomable();
            viewport.paddingHorizontal = 50;
            viewport.paddingVertical   = 50;
            return viewport;
         };
         VIEWPORT_FACTORY_METHODS[BATTLE] = function() : ViewportZoomable
         {
            var viewport:ViewportZoomable = new ViewportZoomable();
            viewport.paddingHorizontal = 50;
            viewport.paddingVertical   = 50;
            return viewport;
         };
      };
      
      
      private static function getViewport(model:MMap) : ViewportZoomable
      {
         return (VIEWPORT_FACTORY_METHODS[model.mapType] as Function).call();
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
      public static function getViewportWithMap(model:MMap) : ViewportZoomable
      {
         var viewport:ViewportZoomable = getViewport(model);
         var map:CMap = getMap(model);
         map.viewport = viewport;
         with (viewport)
         {
            left    = 0;
            right   = 0;
            top     = 0;
            bottom  = 0;
            content = map;
         }
         return viewport;
      }
      
      
      /* ########################################### */
      /* ### VIEWPORT CONTROLLERS FACTORY METHOD ### */
      /* ########################################### */
      
      
      private static const VIEWPORT_CONTROLLERS:Object = new Object();
      with (MapType)
      {
         VIEWPORT_CONTROLLERS[GALAXY]       = GalaxyViewportController;
         VIEWPORT_CONTROLLERS[PLANET]       = ViewportZoomController;
         VIEWPORT_CONTROLLERS[BATTLE]       = null;
         VIEWPORT_CONTROLLERS[SOLAR_SYSTEM] = SolarSystemViewportController;
      };
      
      
      /**
       * Creates and returns instance of specific implementation of <code>IMapViewportController</code>
       * for a given map.
       * 
       * @param model a map to create controller for
       * 
       * @return instance of specific implementation of <code>IMapViewportController</code>
       * suitable for a given map 
       */
      public static function getViewportController(model:MMap) : IMapViewportController
      {
         if (VIEWPORT_CONTROLLERS[model.mapType] != null)
         {
            var controller:IMapViewportController = new (Class(VIEWPORT_CONTROLLERS[model.mapType]))();
            controller.left = 0;
            controller.right = 0;
            controller.top = 0;
            controller.bottom = 0;
            return controller;
         }
         else
         {
            return null;
         }
      }
   }
}
package components.map.planet
{
   import animation.AnimationTimer;
   
   import components.gameobjects.planet.IInteractivePlanetMapObject;
   import components.map.CMap;
   
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.location.LocationMinimal;
   import models.map.MapDimensionType;
   import models.planet.Planet;
   import models.tile.Tile;
   
   import utils.assets.AssetNames;
   
   
   
   
   /**
    * Map of a planet. Probably the most difficult of all.
    */
   public class PlanetMap extends CMap
   {
      /**
       * Called by <code>NavigationController</code> when planet map screen is shown.
       */
      public static function screenShowHandler() : void
      {
         AnimationTimer.forPlanet.start();
      }
      
      
      /**
       * Called by <code>NavigationController</code> when planet map screen is hidden.
       */
      public static function screenHideHandler() : void
      {
         AnimationTimer.forPlanet.stop();
      }
      
      
      /**
       * Size of a border made up from tiles around the actual map.
       */
      internal static const BORDER_SIZE:int = 1;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _backgroundRenderer:BackgroundRenderer = null;
      
      
      /**
       * Constructor.
       * 
       * @param model a planet to create map for
       */
      public function PlanetMap(model:Planet)
      {         
         super(model);
         _coordsTransform = new PlanetMapCoordsTransform(model.width, model.height, BORDER_SIZE);
      }
      
      
      public override function cleanup() : void
      {
         if (_objectsLayer)
         {
            removeElement(_objectsLayer);
            _objectsLayer.cleanup();
            _objectsLayer = null;
         }
         if (_backgroundRenderer)
         {
            _backgroundRenderer.cleanup();
            _backgroundRenderer = null;
         }
         super.cleanup();
      }
      
      
      public override function getBackground() : BitmapData
      {
         if (!_backgroundRenderer)
         {
            _backgroundRenderer = new BackgroundRenderer(this);
         }
         return _backgroundRenderer.renderBackground();
      }
      
      
      protected override function createObjects() : void
      {
         super.createObjects();
         
         _objectsLayer = new PlanetObjectsLayer(this, getPlanet());
         addElement(_objectsLayer);
      }
      
      
      protected override function reset() : void
      {
         if (_objectsLayer != null)
         {
            _objectsLayer.reset();
         }
      }
      
      
      /* ########################### */
      /* ### INTERNAL CONTAINERS ### */
      /* ########################### */
      
      
      /**
       * Container that holds all planet objects.
       */       
      private var _objectsLayer:PlanetObjectsLayer = null;
      
      
//      /**
//       * Clouds layer. Thy dont need fancy depth sorting support found in <code>_objectsLayer</code>
//       * so they are held in another container.
//       */
//      private var _cloudsLayer:CloudsLayer = null;
      
      
      /**
       * Typed getter for property <code>model</code>.
       */      
      public function getPlanet() : Planet
      {
         return Planet(model);
      }
      
      
      protected override function selectObjectImpl(object:*, operationCompleteHandler:Function = null) : void
      {
         var obj:IInteractivePlanetMapObject = IInteractivePlanetMapObject(_objectsLayer.getObjectByModel(object));
         _objectsLayer.selectObject(obj);
         viewport.zoomArea(new Rectangle(obj.x, obj.y, obj.width, obj.height), true, operationCompleteHandler);
      }
      
      
      protected override function centerLocation(location:LocationMinimal,
                                                 operationCompleteHandler:Function) : void
      {
         viewport.moveContentTo(_coordsTransform.logicalToReal(new Point(location.x, location.y)),
                                true, operationCompleteHandler);
      }
      
      
      /* #################################################### */
      /* ### LOGICAL <-> REAL COORDINATES TRANSFORMATION  ### */
      /* #################################################### */
      
      
      private var _coordsTransform:PlanetMapCoordsTransform = null;
      /**
       * Implementation of <code>IMapCoordsTransform</code> used by this planet map.
       */
      public function get coordsTransform() : PlanetMapCoordsTransform
      {
         return _coordsTransform;
      }
   }
}
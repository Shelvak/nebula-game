package components.map.planet
{
   import animation.AnimationTimer;

   import components.map.CMap;
   import components.map.planet.objects.IInteractivePlanetMapObject;

   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   import models.location.LocationMinimal;
   import models.planet.MPlanet;


   /**
    * Map of a planet. Probably the most difficult of all.
    */
   public class PlanetMap extends CMap
   {
      /**
       * Called by <code>NavigationController</code> when planet map screen is shown.
       */
      public static function screenShowHandler(): void {
         AnimationTimer.forPlanet.start();
      }

      /**
       * Called by <code>NavigationController</code> when planet map screen is hidden.
       */
      public static function screenHideHandler(): void {
         AnimationTimer.forPlanet.stop();
      }
      
      /**
       * Size of a border made up from tiles around the actual map.
       */
      public static const BORDER_SIZE:int = 1;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */

      private var _backgroundRenderer: BackgroundRenderer = null;

      /**
       * Constructor.
       *
       * @param model a planet to create map for
       */
      public function PlanetMap(model: MPlanet) {
         super(model);
         _coordsTransform = new PlanetMapCoordsTransform(
            model.width, model.height, BORDER_SIZE
         );
      }

      public override function cleanup(): void {
         if (_objectsLayer != null) {
            removeElement(_objectsLayer);
            _objectsLayer.cleanup();
            _objectsLayer = null;
         }
         if (_backgroundRenderer != null) {
            _backgroundRenderer.cleanup();
            _backgroundRenderer = null;
         }
         super.cleanup();
      }

      public override function getBackground(): BitmapData {
         if (_backgroundRenderer == null) {
            _backgroundRenderer = new BackgroundRenderer(this);
         }
         return _backgroundRenderer.renderBackground();
      }

      protected override function createObjects(): void {
         super.createObjects();
         _objectsLayer = new PlanetObjectsLayer(this, getPlanet());
         addElement(_objectsLayer);
      }

      protected override function reset(): void {
         if (_objectsLayer != null) {
            _objectsLayer.reset();
         }
      }
      
      
      /* ########################### */
      /* ### INTERNAL CONTAINERS ### */
      /* ########################### */
      
      /**
       * Container that holds all planet objects.
       */
      private var _objectsLayer: PlanetObjectsLayer = null;

      /**
       * Typed getter for property <code>model</code>.
       */      
      public function getPlanet() : MPlanet {
         return MPlanet(model);
      }

      protected override function selectLocationImpl(location: LocationMinimal,
                                                     instant: Boolean,
                                                     openOnSecondCall: Boolean,
                                                     operationCompleteHandler: Function = null): void {
         const obj: IInteractivePlanetMapObject =
                IInteractivePlanetMapObject(
                   _objectsLayer.getObjectOnTile(location.x, location.y)
                );
         _objectsLayer.selectObject(obj);
         viewport.zoomArea(
            new Rectangle(obj.x, obj.y, obj.width, obj.height),
            !instant, operationCompleteHandler
         );
      }

      protected override function centerLocation(location: LocationMinimal,
                                                 instant: Boolean,
                                                 operationCompleteHandler: Function): void {
         viewport.moveContentTo(
            _coordsTransform.logicalToReal(new Point(location.x, location.y)),
            !instant, operationCompleteHandler
         );
      }


      /* #################################################### */
      /* ### LOGICAL <-> REAL COORDINATES TRANSFORMATION  ### */
      /* #################################################### */

      private var _coordsTransform: PlanetMapCoordsTransform = null;
      /**
       * Implementation of <code>IMapCoordsTransform</code> used by this planet map.
       */
      public function get coordsTransform(): PlanetMapCoordsTransform {
         return _coordsTransform;
      }
   }
}
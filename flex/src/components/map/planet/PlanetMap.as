package components.map.planet
{
   import animation.AnimationTimer;

   import components.map.CMap;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.planetmapeditor.ObjectsEditorLayer;
   import components.planetmapeditor.TerrainEditorLayer;

   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.planet.events.MPlanetEvent;
   import models.solarsystem.events.MSSObjectEvent;


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

      private var _objectsEditorLayer: ObjectsEditorLayer = null;
      private var _terrainEditorLayer: TerrainEditorLayer = null;

      private var _backgroundRenderer: BackgroundRenderer = null;
      private function get backgroundRenderer(): BackgroundRenderer {
         if (_backgroundRenderer == null) {
            _backgroundRenderer = new BackgroundRenderer(this);
         }
         return _backgroundRenderer;
      }

      /**
       * Constructor.
       *
       * @param model a planet to create map for
       */
      public function PlanetMap(model: MPlanet,
                                objectsEditorLayer: ObjectsEditorLayer = null,
                                terrainEditorLayer: TerrainEditorLayer = null) {
         super(model);
         _objectsEditorLayer = objectsEditorLayer;
         _terrainEditorLayer = terrainEditorLayer;
         _coordsTransform = new PlanetMapCoordsTransform(
            model.width, model.height, BORDER_SIZE
         );
         model.ssObject.addEventListener(
            MSSObjectEvent.TERRAIN_CHANGE,
            ssObject_terrainChangeHandler, false, 0, true
         );
         model.addEventListener(
            MPlanetEvent.UICMD_SELECT_OBJECT,
            model_uicmdSelectObjectHandler, false, 0, true
         );
      }

      public override function cleanup(): void {
         if (model != null) {
            MPlanet(model).ssObject.removeEventListener(
               MSSObjectEvent.TERRAIN_CHANGE,
               ssObject_terrainChangeHandler, false
            );
            model.removeEventListener(
               MPlanetEvent.UICMD_SELECT_OBJECT,
               model_uicmdSelectObjectHandler, false
            );
         }
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

      public override function getBackground(useCached:Boolean = true): BitmapData {
         return backgroundRenderer.renderBackground(useCached);
      }

      internal function getGrid(): BitmapData {
         return backgroundRenderer.renderGrid();
      }

      protected override function createObjects(): void {
         super.createObjects();
         _objectsLayer = new PlanetObjectsLayer(
            this, getPlanet(), _objectsEditorLayer, _terrainEditorLayer
         );
         _objectsEditorLayer = null;
         _terrainEditorLayer = null;
         addElement(_objectsLayer);
      }

      protected override function reset(): void {
         if (_objectsLayer != null) {
            _objectsLayer.reset();
         }
      }

      /**
       * Typed getter for property <code>model</code>.
       */
      public function getPlanet() : MPlanet {
         return MPlanet(model);
      }
      
      
      /* ########################### */
      /* ### INTERNAL CONTAINERS ### */
      /* ########################### */
      
      /**
       * Container that holds all planet objects.
       */
      private var _objectsLayer: PlanetObjectsLayer = null;

      
      /* ################### */
      /* ### UI COMMANDS ### */
      /* ################### */

      private function model_uicmdSelectObjectHandler(event: MPlanetEvent): void {
         const building: MPlanetObject = event.object;
         selectLocationImpl(
            new LocationMinimal(
               LocationType.SS_OBJECT,
               model.id,
               building.x,
               building.y
            ),
            true, true
         );
      }

      protected override function selectLocationImpl(location: LocationMinimal,
                                                     instant: Boolean,
                                                     openOnSecondCall: Boolean,
                                                     operationCompleteHandler: Function = null): void {
         const obj: IInteractivePlanetMapObject =
                IInteractivePlanetMapObject(
                   _objectsLayer.getObjectOnTile(location.x, location.y)
                );
         if (obj != null) {
            _objectsLayer.selectObject(obj);
            viewport.zoomArea(
               new Rectangle(obj.x, obj.y, obj.width, obj.height),
               !instant, operationCompleteHandler
            );
         }
         else {
            centerLocation(location, instant, operationCompleteHandler);
         }
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

      /* #################################### */
      /* ### RUNTIME BACKGROUND RENDERING ### */
      /* #################################### */

      private function ssObject_terrainChangeHandler(event:MSSObjectEvent): void {
         if (_objectsLayer != null) {
            renderBackground(false);
            _objectsLayer.repositionAllObjects();
         }
      }
   }
}
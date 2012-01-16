package components.map
{
   import com.developmentarc.core.utils.EventBroker;

   import components.base.BaseContainer;
   import components.base.viewport.ViewportZoomable;

   import controllers.navigation.MCMainArea;

   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;

   import globalevents.GlobalEvent;

   import interfaces.ICleanable;

   import models.events.ScreensSwitchEvent;
   import models.location.LocationMinimal;
   import models.map.MMap;
   import models.map.events.MMapEvent;

   import mx.graphics.BitmapFillMode;

   import spark.primitives.BitmapImage;


   /**
    * Base class for all maps. A map is not ordinary Flex component and
    * therefore does not follow Flex components lifecycle. Map is drawn,
    * measured and all objects are created when instance is created. Three
    * protected methods must be overriden in order this works properly:
    * <code>getBackground()</code>, <code>getSize()</code> and
    * <code>createObjects()</code> (read documentation of these methods for more
    * information). The methods are called in the order they have been
    * mentioned here.
    * 
    * <p> When you no longer need the map, you <b>must</b> call
    * <code>cleanup()</code> method to remove all event listeners, references
    * to other objects. Not doing so will <b>definitely</b> result in memory
    * leaks and performance loss. You also should override this method to
    * release any additional resources used by the deriving class.</p>
    */
   public class CMap extends BaseContainer implements ICleanable
   {
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      private var _backgroundData:BitmapData = null;
      private var _backgroundComponent:BitmapImage = null;

      public function CMap(model: MMap): void {
         super();
         super.model = model;
         addGlobalEventHandlers();
         addModelEventHandlers(model);
      }
      
      
      /**
       * Called by constructor to get background image of the map. If you don't have or need a
       * background for the map you should not override this method but in that case you <b>must</b>
       * override <code>getSize()</code> because default implementation of that method relies on
       * <code>getBackground()</code>.
       * 
       * @return background image of the map. Default implementation returns <code>null</code>.
       */
      public function getBackground(): BitmapData {
         return null;
      }
      
      /**
       * Called by constructor to set size of the map. You can leave default implementation of this
       * method <b>only if</b> <code>getBackground()</code> does not return <code>null</code> (that
       * means you have implemented it in your own way).
       * 
       * @return a point that defines size of the map: <code>x</code> is width of the map and
       * <code>y</code> is height. Default implemetation returns <code>width</code> and
       * <code>height</code> properties values of <code>getBackground()</code>.
       */
      public function getSize(): Point {
         return new Point(
            getBackground().width,
            getBackground().height
         );
      }

      /**
       * Called in <code>createChildren()</code> to create any objects on the
       * map. You don't have to override this method and can create and remove
       * objects from the map at any time. Default implementation of this method
       * is empty.
       */
      protected function createObjects(): void {
      }
      
      private var f_childrenCreated:Boolean = false;

      protected override function createChildren(): void {
         super.createChildren();
         if (f_childrenCreated) {
            return;
         }

         _backgroundData = getBackground();
         // Create background image component if we got background
         if (_backgroundData != null) {
            _backgroundComponent = new BitmapImage();
            _backgroundComponent.smooth = true;
            _backgroundComponent.fillMode = BitmapFillMode.REPEAT;
            _backgroundComponent.source = _backgroundData;
            addElement(_backgroundComponent);
         }
         createObjects();
         f_childrenCreated = true;
      }

      public function cleanup(): void {
         removeGlobalEventHandlers();
         if (model) {
            removeModelEventHandlers(getModel());
            model = null;
         }
         if (_backgroundComponent) {
            removeElement(_backgroundComponent);
            _backgroundComponent.source = null;
            _backgroundComponent = null;
            _backgroundData = null;
         }
         _viewport = null;
      }


      /* ######################## */
      /* ### SIZE AND VISUALS ### */
      /* ######################## */
      
      protected override function measure() : void {
         var size:Point = getSize();
         measuredWidth = size.x;
         measuredHeight = size.y;
      }
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void {
         super.updateDisplayList(uw, uh);
         if (_backgroundComponent) {
            _backgroundComponent.width = uw;
            _backgroundComponent.height = uh;
         }
      }      

      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var f_viewportSet:Boolean = false;
      private var _viewport:ViewportZoomable = null;
      /**
       * A viewport that is responsible for moving and zooming this map. This is a
       * write-once-read-many property.
       */
      public function set viewport(value: ViewportZoomable): void {
         if (f_viewportSet) {
            throwWriteOncePropertyError();
         }
         if (_viewport != value) {
            _viewport = value;
            f_viewportSet = true;
         }
      }
      /**
       * @private
       */
      public function get viewport() : ViewportZoomable {
         return _viewport;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * When this method is invoked the map should select given location if
       * that location is defined in the map and if there is a static object in
       * that location In <code>CMap</code> this method is empty. Second call to
       * this method should open the navigable static object in that location.
       * 
       * @param location a location that should be selected
       * @param center indicates if the component should be moved to the center
       *        of the viewport
       * @param openOnSecondCall if <code>true</code> and <code>location</code>
       *        is the location already selected, the navigable object in this
       *        location will be opened.
       */
      public function selectLocation(location: LocationMinimal,
                                     center: Boolean = false,
                                     openOnSecondCall: Boolean = false): void {
      }
      
      /**
       * Opens (navigates to) a static navigable object in the given location.
       * In <code>CMap</code> this method is empty
       * 
       * @param location a location defined by the map
       */
      public function openLocation(location: LocationMinimal): void {
      }
      
      /**
       * When this method is invoked the map should deselect selected location.
       * In <code>CMap</code> this method is empty.
       */
      public function deselectSelectedLocation(): void {
      }
      
      /**
       * When invoked, map should reset itself to initial state. This is an empty method in
       * <code>CMap</code>: override if needed.
       */
      protected function reset(): void {
      }
      
      protected function centerLocation(location: LocationMinimal,
                                        instant: Boolean,
                                        operationCompleteHandler: Function) : void {
      }
      
      protected function zoomLocationImpl(location: LocationMinimal,
                                          instant: Boolean,
                                          operationCompleteHandler: Function = null) : void {
      }
      
      protected function selectLocationImpl(location: LocationMinimal,
                                            instant: Boolean,
                                            openOnSecondCall: Boolean,
                                            operationCompleteHandler: Function = null) : void {
         selectLocation(location, !instant, openOnSecondCall);
         callOperationCompleteHandler(operationCompleteHandler);
      }

      protected function deselectSelectedLocationImpl(operationCompleteHandler:Function = null) : void {
         deselectSelectedLocation();
         callOperationCompleteHandler(operationCompleteHandler);
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */

      private function get MA(): MCMainArea {
         return MCMainArea.getInstance();
      }

      protected function addGlobalEventHandlers(): void {
         MA.addEventListener(
            ScreensSwitchEvent.SCREEN_CHANGING, mainAreaChangingHandler
         );
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }

      protected function removeGlobalEventHandlers(): void {
         MA.removeEventListener(
            ScreensSwitchEvent.SCREEN_CHANGING, mainAreaChangingHandler
         );
         EventBroker.unsubscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }

      private function mainAreaChangingHandler(event: ScreensSwitchEvent): void {
         reset();
      }

      private function global_appResetHandler(event: GlobalEvent): void {
         cleanup();
      }
      
      protected function addModelEventHandlers(model:MMap) : void {
         model.addEventListener(
            MMapEvent.UICMD_ZOOM_LOCATION,
            model_uicmdZoomLocationHandler, false, 0, true
         );
         model.addEventListener(
            MMapEvent.UICMD_SELECT_LOCATION,
            model_uicmdSelectLocationHandler, false, 0, true
         );
         model.addEventListener(
            MMapEvent.UICMD_DESELECT_SELECTED_LOCATION,
            model_uicmdDeselectSelectedLocationHandler, false, 0, true
         );
         model.addEventListener(
            MMapEvent.UICMD_MOVE_TO_LOCATION,
            model_uicmdMoveToLocationHandler, false, 0, true
         );
      }
      
      protected function removeModelEventHandlers(model:MMap) : void {
         model.removeEventListener(
            MMapEvent.UICMD_ZOOM_LOCATION,
            model_uicmdZoomLocationHandler, false
         );
         model.removeEventListener(
            MMapEvent.UICMD_SELECT_LOCATION,
            model_uicmdSelectLocationHandler, false
         );
         model.removeEventListener(
            MMapEvent.UICMD_DESELECT_SELECTED_LOCATION,
            model_uicmdDeselectSelectedLocationHandler, false
         );
         model.removeEventListener(
            MMapEvent.UICMD_MOVE_TO_LOCATION,
            model_uicmdMoveToLocationHandler, false
         );
      }

      private function model_uicmdZoomLocationHandler(event: MMapEvent): void {
         if (viewport != null) {
            zoomLocationImpl(
               event.object, event.instant, event.operationCompleteHandler
            );
         }
      }

      private function model_uicmdSelectLocationHandler(event: MMapEvent): void {
         if (viewport != null) {
            selectLocationImpl(
               event.object, event.instant, event.openOnSecondCall,
               event.operationCompleteHandler
            );
         }
      }

      private function model_uicmdDeselectSelectedLocationHandler(event: MMapEvent): void {
         if (viewport != null) {
            deselectSelectedLocationImpl(event.operationCompleteHandler);
         }
      }

      private function model_uicmdMoveToLocationHandler(event: MMapEvent): void {
         if (viewport != null) {
            centerLocation(
               event.object, event.instant, event.operationCompleteHandler
            );
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      public function getModel(): MMap {
         return MMap(model);
      }

      private function callOperationCompleteHandler(handler: Function): void {
         if (handler != null) {
            handler.call();
         }
      }

      /**
       * @throws IllegalOperationError
       */
      private function throwWriteOncePropertyError(): void {
         throw new IllegalOperationError("This property is of write-once type: it can be set only once");
      }
   }
}
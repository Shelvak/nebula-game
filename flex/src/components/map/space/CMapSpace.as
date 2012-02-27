package components.map.space
{
   import components.base.viewport.ViewportZoomable;
   import components.base.viewport.events.ViewportEvent;
   import components.map.CMap;
   import components.movement.speedup.CSpeedControlPopup;
   import components.movement.speedup.CSpeedControlPopupM;
   import components.movement.CSquadronMapIcon;
   import components.movement.CSquadronPopup;
   import components.movement.CTargetLocationPopup;

   import controllers.timedupdate.IUpdateTriggerTemporary;
   import controllers.timedupdate.TemporaryUpdateTrigger;
   import controllers.units.OrdersController;
   import controllers.units.events.OrdersControllerEvent;

   import flash.events.MouseEvent;
   import flash.geom.Point;

   import models.MWreckage;
   import models.location.LocationMinimal;
   import models.map.IMStaticSpaceObject;
   import models.map.MMap;
   import models.map.MMapSpace;
   import models.map.MStaticSpaceObjectsAggregator;
   import models.map.events.MMapEvent;

   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;

   import spark.components.Group;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   import spark.primitives.BitmapImage;

   import utils.DateUtil;
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.components.DisplayListUtil;


   public class CMapSpace extends CMap
   {
      private function get ORDERS_CTRL() : OrdersController {
         return OrdersController.getInstance();
      }


      private function get TMP_UPDATE_TRG() : IUpdateTriggerTemporary {
         return TemporaryUpdateTrigger.getInstance();
      }


      /**
       * How much popup with information about static objects in a sector must be shifted down
       * from the center of the sector.
       */
      internal static const OBJECT_POPUP_YSHIFT:int = 20;

      private function get logger(): ILogger {
         return Log.getLogger(Objects.getClassName(this, true));
      }


      internal var grid:Grid;
      internal var squadronsController:SquadronsController;


      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */

      public function CMapSpace(model: MMapSpace) {
         super(model);
         doubleClickEnabled = true;
         addSelfEventHandlers();
         addOrdersControllerEventHandlers();
      }

      /**
       * Creates concrete instance of <code>Grid</code> for use in a map.
       */
      protected function createGrid(): Grid {
         Objects.throwAbstractMethodError();
         return null;
      }

      public override function getSize(): Point {
         return grid.getRealMapSize();
      }

      private var f_cleanupCalled:Boolean = false;
      public override function cleanup(): void {
         if (f_cleanupCalled) {
            return;
         }
         f_cleanupCalled = true;
         if (model != null) {
            deselectSelectedLocation();
         }
         if (squadronsController != null) {
            squadronsController.cleanup();
            squadronsController = null;
         }
         if (grid != null) {
            grid.cleanup();
            grid = null;
         }
         if (viewport != null) {
            removeViewportEventHandlers(viewport);
         }
         if (targetLocationPopup != null) {
            passivateTargetLocationPopup();
            targetLocationPopup.cleanup();
            targetLocationPopup = null;
         }
         if (speedControlPopup != null) {
            passivateSpeedControlPopup();
            speedControlPopup = null;
         }
         removeOrdersControllerEventHandlers();
         super.cleanup();
      }

      protected override function reset(): void {
         deselectSelectedLocation();
      }


      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      public override function set viewport(value: ViewportZoomable): void {
         if (viewport != value) {
            super.viewport = value;
            addViewportEventHandlers(viewport);
         }
      }


      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */

      /**
       * Objects in the background. Will not receive any events.
       */
      private var _backgroundObjectsCont:Group;

      private var _staticObjectsCont:Group;
      /**
       * Routes (layer above static objects)
       */
      internal var routeObjectsCont:Group;

      /**
       * Squadrons that move (layer above route objects).
       */
      internal var squadronObjectsCont:Group;

      /**
       * Top layer: all popup windows are put here.
       */
      private var popupsCont:Group;

      protected override function createObjects() : void {
         super.createObjects();

         function createContainer(): Group {
            var container: Group = new Group();
            container.mouseEnabled = false;
            addElement(container);
            return container;
         }

         grid = createGrid();

         _backgroundObjectsCont = createContainer();
         _backgroundObjectsCont.mouseChildren = false;
         createBackgroundObjects(_backgroundObjectsCont);

         _staticObjectsCont = createContainer();
         createStaticObjects(_staticObjectsCont);

         routeObjectsCont = createContainer();
         routeObjectsCont.mouseEnabled = true;

         squadronObjectsCont = createContainer();
         squadronsController = new SquadronsController(this);

         addElement(grid);

         popupsCont = createContainer();
         createPopupObjects(popupsCont);

         invalidateObjectsPosition();
      }


      /**
       * Override this to create background objects of custom space map.
       *
       * @param objectsContainer container you should add all background objects to
       */
      protected function createBackgroundObjects(objectsContainer: Group): void {
      }

      protected function createCustomComponentClasses(): StaticObjectComponentClasses {
         Objects.throwNotSupportedMethodError();
         return null;   // unreachable
      }

      protected function createStaticObjects(objectsContainer:Group) : void {
         for each (var object:IMStaticSpaceObject in MMapSpace(model).objects) {
            createOrUpdateStaticObject(object);
         }
      }

      protected function createOrUpdateStaticObject(object:IMStaticSpaceObject): void {
         var aggregatorIdx: int = getAggregatorComponentIndex(
            object.currentLocation
         );
         var aggregatorModel: MStaticSpaceObjectsAggregator;
         var aggregatorComponent: CStaticSpaceObjectsAggregator;
         if (aggregatorIdx < 0) {
            aggregatorModel = new MStaticSpaceObjectsAggregator();
            aggregatorModel.addItem(object);
            aggregatorComponent = new CStaticSpaceObjectsAggregator(
               aggregatorModel, customComponentClasses
            );
            _staticObjectsCont.addElement(aggregatorComponent);
            grid.positionStaticObjectInSector(object.currentLocation);
         }
         else {
            aggregatorComponent = CStaticSpaceObjectsAggregator(
               _staticObjectsCont.getElementAt(aggregatorIdx)
            );
            aggregatorComponent.model.addItem(object);
         }
         if (squadronsController != null) {
            squadronsController.repositionAllSquadronsIn(
               object.currentLocation
            );
         }
      }

      protected function destroyOrUpdateStaticObject(object:IMStaticSpaceObject): void {
         var aggregatorIdx:int = getAggregatorComponentIndex(object.currentLocation);
         var aggregatorComponent: CStaticSpaceObjectsAggregator =
                CStaticSpaceObjectsAggregator(
                   _staticObjectsCont.getElementAt(aggregatorIdx)
                );
         aggregatorComponent.model.removeItemAt(
            aggregatorComponent.model.getItemIndex(object)
         );
         if (aggregatorComponent.model.length == 0) {
            _staticObjectsCont.removeElementAt(aggregatorIdx);
         }
         if (squadronsController != null) {
            squadronsController.repositionAllSquadronsIn(
               object.currentLocation
            );
         }
      }


      /* ######################## */
      /* ### SIZE AND VISUALS ### */
      /* ######################## */

      protected var f_objectsPositionInvalid:Boolean = true;
      protected function invalidateObjectsPosition(): void {
         if (!f_objectsPositionInvalid) {
            f_objectsPositionInvalid = true;
            invalidateDisplayList();
         }
      }

      protected override function updateDisplayList(uw: Number,
                                                    uh: Number): void {
         super.updateDisplayList(uw, uh);
         grid.width = uw;
         grid.height = uh;
         popupsCont.width = uw;
         popupsCont.height = uh;
         _backgroundObjectsCont.width = uw;
         _backgroundObjectsCont.height = uh;
         _staticObjectsCont.width = uw;
         _staticObjectsCont.height = uh;
         routeObjectsCont.width = uw;
         routeObjectsCont.height = uh;
         squadronObjectsCont.width = uw;
         squadronObjectsCont.height = uh;
         if (f_objectsPositionInvalid) {
            grid.positionStaticObjects();
            squadronsController.repositionAllSquadrons();
            squadronsController.updateOrderSourceLocIndicator();
            f_objectsPositionInvalid = false;
         }
      }


      /* ############## */
      /* ### POPUPS ### */
      /* ############## */


      /**
       * When user clicks on a squadron indicator, this component shows all sorts of information
       * about squadrons and units.
       */
      internal var squadronsInfo:CSquadronPopup;

      // see ordersController_uicmdShowSpeedUpPopupHandler()
      private var _targetLocationPopup_locationPlanet:LocationMinimal;
      private var _targetLocationPopup_locationSpace:LocationMinimal;

      private function nullifyTargetLocationPopupStateVars(): void {
         _targetLocationPopup_locationPlanet = null;
         _targetLocationPopup_locationSpace = null;
      }

      /**
       * User will use this to confirm target location or cancel orders. Shown when user clicks on a an empty
       * space and <code>GlobalFlags.issuingOrders</code> is <code>true</code>.
       */
      internal var targetLocationPopup:CTargetLocationPopup;

      /**
       * Restores <code>orderPopup.locationPlanet</code> and <code>orderPopup.locationSpace</code> from
       * <code>_orderPopup_*</code> variables.
       */
      private function activateTargetLocationPopup(): void {
         Objects.notNull(
            targetLocationPopup, "[prop targetLocationPopup] can't be null"
         );
         targetLocationPopup.locationPlanet = _targetLocationPopup_locationPlanet;
         targetLocationPopup.locationSpace = _targetLocationPopup_locationSpace;
      }

      /**
       * Hides <code>orderPopup</code>. Sets <code>locationPlanet</code> and <code>locationSpace</code> to
       * <code>null</code>.
       */
      internal function passivateTargetLocationPopup(): void {
         Objects.notNull(
            targetLocationPopup,
            "[prop targetLocationPopup] can't be null"
         );
         targetLocationPopup.locationPlanet = null;
         targetLocationPopup.locationSpace = null;
         targetLocationPopup.includeInLayout = false;
         targetLocationPopup.visible = false;
         targetLocationPopup.enabled = true;
      }

      /**
       * Allows to speed up or slow down movement of a squad.
       */
      private var speedControlPopup: CSpeedControlPopup;

      /**
       * Hides <code>speedControlPopup</code>
       */
      internal function passivateSpeedControlPopup(): void {
         Objects.notNull(
            speedControlPopup,
            "[prop speedControlPopup] can't be null"
         );
         if (speedControlPopup.model != null) {
            TMP_UPDATE_TRG.unregister(speedControlPopup.model);
            speedControlPopup.model.cleanup();
         }
         speedControlPopup.model = null;
         speedControlPopup.visible = false;
         speedControlPopup.includeInLayout = false;
      }

      protected function activateSpeedControlPopup(model: CSpeedControlPopupM): void {
         if (!getModel().definesLocation(ORDERS_CTRL.locationTarget)) {
            return;
         }
         Objects.notNull(
            speedControlPopup, "[prop speedControlPopup] can't be null"
         );
         speedControlPopup.model = Objects.paramNotNull("model", model);
         speedControlPopup.visible = true;
         speedControlPopup.includeInLayout = true;
         model.onCancel = speedControlPopup_onCancel;
         TMP_UPDATE_TRG.register(model);
      }

      private function speedControlPopup_onCancel(): void {
         activateTargetLocationPopup();
         passivateSpeedControlPopup();
      }

      /**
       * This will be visible if player is issuing orders and will indicate where source location of
       * that order (location where units currently are) is.
       */
      internal var orderSourceLocIndicator:BitmapImage;

      /**
       * This is visible when player selects a static object and holds information about all static objects
       * in that place.
       */
      internal var staticObjectsPopup:CStaticSpaceObjectsPopup;

      /**
       * Aggregates popups could be shown in the same sector at the same time. For now they are
       * <code>orderPopup</code> and <code>staticObjectsPopup</code>.
       */
      internal var sectorPopups:Group;

      /**
       * Shown in the top right corner when player rolls the mouse over a wreckage.
       */
      private var _wreckageTooltip:CWreckageInfo;

      /**
       * Invoked by <code>grid</code> to reposition <code>sectorPopups</code>.
       */
      internal function positionSectorPopups(newPosition:Point) : void {
         Objects.paramNotNull("newPosition", newPosition);
         sectorPopups.x = newPosition.x;
         sectorPopups.y = newPosition.y;
      }

      /**
       * Creates popup components.
       *
       * @param objectsContainer container you should add all popup objects to
       */
      protected function createPopupObjects(objectsContainer:Group) : void {
         orderSourceLocIndicator = new BitmapImage();
         orderSourceLocIndicator.visible = false;
         orderSourceLocIndicator.source =
            IMG.getImage(AssetNames.MOVEMENT_IMAGES_FOLDER + "order_from_indicator");
         objectsContainer.addElement(orderSourceLocIndicator);

         squadronsInfo = new CSquadronPopup();
         squadronsInfo.visible = false;
         objectsContainer.addElement(squadronsInfo);

         targetLocationPopup = new CTargetLocationPopup();
         targetLocationPopup.percentWidth = 100;
         passivateTargetLocationPopup();

         speedControlPopup = new CSpeedControlPopup();
         speedControlPopup.percentWidth = 100;
         passivateSpeedControlPopup();

         staticObjectsPopup = new CStaticSpaceObjectsPopup(customComponentClasses);
         staticObjectsPopup.visible = false;
         staticObjectsPopup.includeInLayout = false;

         var vLayout:VerticalLayout = new VerticalLayout();
         vLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
         vLayout.gap = 5;
         sectorPopups = new Group();
         sectorPopups.width = 222;
         sectorPopups.mouseEnabled = false;
         sectorPopups.layout = vLayout;
         sectorPopups.addElement(targetLocationPopup);
         sectorPopups.addElement(speedControlPopup);
         sectorPopups.addElement(staticObjectsPopup);
         objectsContainer.addElement(sectorPopups);

         // Not really a popup but makes most sense to out this code here
         _wreckageTooltip = new CWreckageInfo();
         _wreckageTooltip.mouseEnabled = false;
         _wreckageTooltip.mouseChildren = false;
         _wreckageTooltip.right = 0;
         _wreckageTooltip.top = 0;
         _wreckageTooltip.visible = false;
         _wreckageTooltip.setStyle("skinClass", CWreckageTooltipSkin);
         var overlay:Group = new Group();
         overlay.addElement(_wreckageTooltip);
         viewport.overlay = overlay;
      }


      /* ################################ */
      /* ### USER GESTURES PROCESSING ### */
      /* ################################ */

      /**
       * Called when user click on an empty space. <code>CMapSpace</code> will cancel all selections
       * made by a user.
       */
      protected function emptySpace_clickHandler(): void {
         deselectSelectedLocation();
         squadronsController.deselectSelectedSquadron();
         nullifyTargetLocationPopupStateVars();
         passivateTargetLocationPopup();
         passivateSpeedControlPopup();
      }

      /**
       * Called when user clicks on <code>CSquadronsMapIcon</code> component. Delegates event
       * handling for <code>SquadronsController</code>.
       */
      protected function squadrons_clickHandler(component:CSquadronMapIcon): void {
         squadronsController.selectSquadron(component);
      }

      /**
       * Called when user clicks on a static object. Calls <code>selectComponent()</code>
       * method.
       */
      protected function staticObject_clickHandler(object: CStaticSpaceObjectsAggregator): void {
         selectLocation(object.currentLocation);
      }

      /**
       * Called when user double-clicks on a static object. Calls <code>openComponent()</code>
       * method.
       */
      protected function staticObject_doubleClickHandler(object: CStaticSpaceObjectsAggregator): void {
         openLocation(object.currentLocation);
      }


      /* ############################### */
      /* ### STATIC OBJECT SELECTION ### */
      /* ############################### */

      protected var selectedLocation:LocationMinimal;

      public override function selectLocation(location:LocationMinimal,
                                              center: Boolean = false,
                                              openOnSecondCall: Boolean = false) : void {
         Objects.paramNotNull("location", location);
         if (location.equals(selectedLocation)) {
            if (openOnSecondCall) {
               openLocation(location);
               return;
            }
         }
         deselectSelectedLocation();
         selectedLocation = location;

         const position:Point = grid.getSectorRealCoordinates(location);
         if (center) {
            viewport.moveContentTo(position, true);
         }

         const staticObject:CStaticSpaceObjectsAggregator =
                  grid.getStaticObjectInSector(location);
         if (staticObject == null) {
            return;
         }
         staticObjectsPopup.model = staticObject.model;
         staticObjectsPopup.visible = true;
         staticObjectsPopup.includeInLayout = true;

         sectorPopups.move(position.x, position.y);
         VerticalLayout(sectorPopups.layout).paddingTop = OBJECT_POPUP_YSHIFT;
         staticObject.selected = true;
         if (ORDERS_CTRL.issuingOrders) {
            grid.issueOrderToLocationUnderMouse(location);
         }
      }

      public override function openLocation(location: LocationMinimal): void {
         Objects.paramNotNull("location", location);
         var staticObject:CStaticSpaceObjectsAggregator =
                grid.getStaticObjectInSector(location);
         if (staticObject != null && staticObject.isNavigable) {
            staticObject.navigateTo();
         }
      }

      public override function deselectSelectedLocation() : void {
         if (selectedLocation != null) {
            staticObjectsPopup.model = null;
            staticObjectsPopup.visible = false;
            staticObjectsPopup.includeInLayout = false;
            const selectedObject:CStaticSpaceObjectsAggregator =
               grid.getStaticObjectInSector(selectedLocation);
            if (selectedObject != null) {
               selectedObject.selected = false;
            }
            selectedLocation = null;
            VerticalLayout(sectorPopups.layout).paddingTop = 0;
         }
      }

      protected override function zoomLocationImpl(location: LocationMinimal,
                                                   instant: Boolean,
                                                   operationCompleteHandler: Function = null): void {
         viewport.zoomPoint(
            grid.getSectorRealCoordinates(location),
            !instant, operationCompleteHandler
         );
      }

      protected override function centerLocation(location: LocationMinimal,
                                                 instant: Boolean,
                                                 operationCompleteHandler: Function) : void {
         viewport.moveContentTo(
            grid.getSectorRealCoordinates(location),
            !instant, operationCompleteHandler
         );
      }


      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */

      /**
       * Returns a list of static objects on the map.
       */
      public function getStaticObjects(): ArrayCollection {
         return DisplayListUtil.getChildren(_staticObjectsCont);
      }


      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */

      protected override function addModelEventHandlers(model: MMap): void {
         super.addModelEventHandlers(model);
         model.addEventListener(
            MMapEvent.OBJECT_ADD, model_objectAdd, false, 0, true
         );
         model.addEventListener(
            MMapEvent.OBJECT_REMOVE, model_objectRemove, false, 0, true
         );
      }

      protected override function removeModelEventHandlers(model: MMap): void {
         model.removeEventListener(
            MMapEvent.OBJECT_ADD, model_objectAdd, false
         );
         model.removeEventListener(
            MMapEvent.OBJECT_REMOVE, model_objectRemove, false
         );
         super.removeModelEventHandlers(model);
      }

      private function model_objectAdd(event: MMapEvent): void {
         // This may not be true if a message related with map objects is
         // processed before the map has actually been created
         if (f_childrenCreated) {
            createOrUpdateStaticObject(event.object);
         }
      }

      private function model_objectRemove(event: MMapEvent): void {
         // This may not be true if a message related with map objects is
         // processed before the map has actually been created
         if (f_childrenCreated) {
            destroyOrUpdateStaticObject(event.object);
         }
      }


      /* ####################################### */
      /* ### OrdersController EVENT HANDLERS ### */
      /* ####################################### */

      private function addOrdersControllerEventHandlers(): void {
         ORDERS_CTRL.addEventListener(
            OrdersControllerEvent.UICMD_ACTIVATE_SPEED_UP_POPUP,
            ordersController_uicmdShowSpeedUpPopupHandler, false, 0, true
         );
      }

      private function removeOrdersControllerEventHandlers(): void {
         ORDERS_CTRL.removeEventListener(
            OrdersControllerEvent.UICMD_ACTIVATE_SPEED_UP_POPUP,
            ordersController_uicmdShowSpeedUpPopupHandler, false
         );
      }

      private function ordersController_uicmdShowSpeedUpPopupHandler(event: OrdersControllerEvent): void {
         // Now this should be impossible, but in practice it sometimes happens:
         // http://forum.nebula44.lt/topic/1544/siunciant-laivus/
         // Judging from the log, this can't happen in the map which is open
         // right now because units|move_meta would fail also and it didn't
         // So that leaves some not completely destroyed map in the memory
         // which somehow failed to unregister this listener in the cleanup()
         // Is there anything that I don't know how EventDispatcher works?
         if (targetLocationPopup == null) {
            if (f_cleanupCalled) {
               logger.warn(
                  "@ordersController_uicmdShowSpeedUpPopupHandler(): "
                     + "cleanup() has already been called but listener "
                     + "has not been removed from OrdersController!"
               );
            }
            logger.warn(
               "@ordersController_uicmdShowSpeedUpPopupHandler(): "
                  + "targetLocationPopup is null, returning."
            );
            return;
         }
         /**
          * Save locationPlanet and locationSpace from targetLocationPopup so that we could restore the popup
          * if player decides to change target location instead of confirming the order.
          */
         _targetLocationPopup_locationPlanet = targetLocationPopup.locationPlanet;
         _targetLocationPopup_locationSpace = targetLocationPopup.locationSpace;
         passivateTargetLocationPopup();

         activateSpeedControlPopup(
            new CSpeedControlPopupM(
               Math.floor(event.arrivalTime - DateUtil.now) / 1000,
               event.hopCount
            )
         );
      }


      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */


      private function addSelfEventHandlers(): void {
         addEventListener(
            FlexEvent.CREATION_COMPLETE,
            this_creationCompleteHandler, false, 0, true
         );
         addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
         addEventListener(
            MouseEvent.DOUBLE_CLICK, this_doubleClickHandler, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_MOVE, this_mouseMoveHandler, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_OVER, this_mouseOverHandler, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_OUT, this_mouseOutHandler, false, 0, true
         );
      }

      private function this_mouseOutHandler(event: MouseEvent): void {
         if (event.target == this ||
                event.target is CStaticSpaceObjectsAggregator) {
            _wreckageTooltip.visible = false;
            _wreckageTooltip.staticObject = null;
         }
      }

      private function this_mouseOverHandler(event: MouseEvent): void {
         if (event.target is CStaticSpaceObjectsAggregator) {
            var wreckage: MWreckage = MWreckage(
               CStaticSpaceObjectsAggregator(event.target)
                  .model
                  .findObjectOfType(MMapSpace.STATIC_OBJECT_WRECKAGE)
            );
            if (wreckage != null) {
               _wreckageTooltip.staticObject = wreckage;
               _wreckageTooltip.visible = true;
            }
         }
      }

      protected function this_creationCompleteHandler(event: FlexEvent): void {
         if (squadronsController != null) {
            squadronsController.updateOrderSourceLocIndicator();
         }
      }

      /**
       * <code>MouseEvent.CLICK</code> event handler. Distributes event handling for different
       * "sub-handlers" by the event target object type.
       */
      protected function this_clickHandler(event:MouseEvent) : void {
         // User clicked on a squadrons indicator
         if (event.target is CSquadronMapIcon) {
            emptySpace_clickHandler();
            squadrons_clickHandler(CSquadronMapIcon(event.target));
         }
         // User clicked on a static map object
         else if (event.target is CStaticSpaceObjectsAggregator) {
            if (!ORDERS_CTRL.issuingOrders) {
               nullifyTargetLocationPopupStateVars();
               passivateTargetLocationPopup();
            }
            passivateSpeedControlPopup();
            squadronsController.deselectSelectedSquadron();
            staticObject_clickHandler(
               CStaticSpaceObjectsAggregator(event.target)
            );
         }
         // As no other types of objects are on the map, pass this event for grid
         else {
            if (!ORDERS_CTRL.issuingOrders) {
               deselectSelectedLocation();
               nullifyTargetLocationPopupStateVars();
               passivateTargetLocationPopup();
            }
            passivateSpeedControlPopup();
            squadronsController.deselectSelectedSquadron();
            grid.map_clickHandler(event);
         }
      }

      protected function this_doubleClickHandler(event: MouseEvent): void {
         if (event.target is CStaticSpaceObjectsAggregator) {
            staticObject_doubleClickHandler(
               CStaticSpaceObjectsAggregator(event.target)
            );
         }
         else if (ORDERS_CTRL.issuingOrders) {
            const mouseLocation:LocationMinimal =
                     grid.getSectorLocation(new Point(mouseX, mouseY));
            if (mouseLocation != null) {
               const staticObject: CStaticSpaceObjectsAggregator =
                        grid.getStaticObjectInSector(mouseLocation);
               if (staticObject != null) {
                  staticObject_doubleClickHandler(staticObject);
               }
            }
         }
      }

      protected function this_mouseMoveHandler(event:MouseEvent): void {
         grid.map_mouseMoveHandler(event);
      }


      /* ############################### */
      /* ### VIEWPORT EVENT HANDLERS ### */
      /* ############################### */

      private function addViewportEventHandlers(viewport: ViewportZoomable): void {
         viewport.addEventListener(
            ViewportEvent.CLICK_EMPTY_SPACE,
            viewport_clickEmptySpaceHandler, false, 0, true
         );
      }

      private function removeViewportEventHandlers(viewport: ViewportZoomable): void {
         viewport.removeEventListener(
            ViewportEvent.CLICK_EMPTY_SPACE,
            viewport_clickEmptySpaceHandler, false
         );
      }

      private function viewport_clickEmptySpaceHandler(event: ViewportEvent): void {
         emptySpace_clickHandler();
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getAggregatorComponentIndex(location: LocationMinimal): int {
         for (var i: int = 0; i < _staticObjectsCont.numElements; i++) {
            var component: CStaticSpaceObjectsAggregator =
                   CStaticSpaceObjectsAggregator(
                      _staticObjectsCont.getElementAt(i)
                   );
            if (component.currentLocation.equals(location)) {
               return i;
            }
         }
         return -1;
      }

      private var _customComponentClasses: StaticObjectComponentClasses;
      private function get customComponentClasses(): StaticObjectComponentClasses {
         if (!_customComponentClasses) {
            _customComponentClasses = createCustomComponentClasses();
         }
         return _customComponentClasses;
      }
   }
}
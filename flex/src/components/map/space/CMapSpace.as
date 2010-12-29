package components.map.space
{
   import components.base.viewport.ViewportZoomable;
   import components.base.viewport.events.ViewportEvent;
   import components.map.CMap;
   import components.movement.COrderPopup;
   import components.movement.CSquadronMapIcon;
   import components.movement.CSquadronPopup;
   
   import controllers.units.OrdersController;
   
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.BaseModel;
   import models.MStaticSpaceObjectsAggregator;
   import models.location.LocationMinimal;
   import models.map.MMap;
   import models.map.MMapSpace;
   import models.map.events.MMapSpaceEvent;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   import utils.components.DisplayListUtil;
   
   
   public class CMapSpace extends CMap
   {
      internal var grid:Grid;
      internal var squadronsController:SquadronsController;
      
      
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       */
      public function CMapSpace(model:MMapSpace)
      {
         super(model);
         addSelfEventHandlers();
      }
      
      
      /**
       * Creates concrete instance of <code>Grid</code> for use in a map. 
       */
      protected function createGrid() : Grid
      {
         throwIllegalOperationError();
         return null;
      }
      
      
      public override function getSize() : Point
      {
         return grid.getRealMapSize();
      }
      
      
      public override function cleanup() : void
      {
         if (model)
         {
            deselectSelectedObject();
         }
         if (squadronsController)
         {
            squadronsController.cleanup();
            squadronsController = null;
         }
         if (grid)
         {
            grid.cleanup();
            grid = null;
         }
         if (viewport)
         {
            removeViewportEventHandlers(viewport);
         }
         super.cleanup();
      }
      
      
      protected override function reset() : void
      {
         deselectSelectedObject();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public override function set viewport(value:ViewportZoomable):void
      {
         if (viewport != value)
         {
            super.viewport = value;
            addViewportEventHandlers(viewport);
         }
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      /**
       * A container which will hold all other containers that must appear in the minimap.
       */
      private var _snapshotObjectsContainer:Group;
      
      
      /**
       * Objects in the background. Will not receive any events.
       */
      private var _backgroundObjectsCont:Group;
      
      
      /**
       * Static objects (layers above background objects)
       */
      private var _staticObjectsCont:Group;
      protected function get staticObjectsContainer() : Group
      {
         return _staticObjectsCont;
      }
      
      
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
      
      
      protected override function createObjects() : void
      {
         super.createObjects();
         var createContainer:Function = function() : Group
         {
            var container:Group = new Group();
            container.mouseEnabled = false;
            _snapshotObjectsContainer.addElement(container);
            return container;
         };
         
         _snapshotObjectsContainer = new Group();
         _snapshotObjectsContainer.mouseEnabled = false;
         addElement(_snapshotObjectsContainer);
         
         grid = createGrid();
         addElement(grid);
         
         popupsCont = new Group();
         popupsCont.mouseEnabled = false;
         addElement(popupsCont);
         createPopupObjects(popupsCont);
         
         _backgroundObjectsCont = createContainer();
         _backgroundObjectsCont.mouseChildren = false;
         createBackgroundObjects(_backgroundObjectsCont);
         
         _staticObjectsCont = createContainer();
         createStaticObjects(_staticObjectsCont);
         
         routeObjectsCont = createContainer();
         routeObjectsCont.mouseEnabled = true;
         
         squadronObjectsCont = createContainer();
         squadronsController = new SquadronsController(this);
         
         invalidateObjectsPosition();
      }
      
      
      /**
       * Override this to create background objects of custom space map.
       * 
       * @param objectsContainer container you should add all background objects to
       */
      protected function createBackgroundObjects(objectsContainer:Group) : void
      {
      }
      
      
      protected function createCustomComponentClasses() : StaticObjectComponentClasses
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      private function createStaticObjects(objectsContainer:Group) : void
      {
         for each (var aggregator:MStaticSpaceObjectsAggregator in MMapSpace(model).objects)
         {
            createStaticObject(aggregator);
         }
      }
      
      
      private function createStaticObject(model:MStaticSpaceObjectsAggregator) : void
      {
         _staticObjectsCont.addElement(new CStaticSpaceObjectsAggregator(model, customComponentClasses));
      }
      
      
      private function destroyStaticObject(loction:LocationMinimal) : void
      {
         _staticObjectsCont.removeElementAt(getAggregatorComponentIndex(loction));
      }
      
      
      /* ######################## */
      /* ### SIZE AND VISUALS ### */
      /* ######################## */
      
      
      protected var f_objectsPositionInvalid:Boolean = true;
      protected function invalidateObjectsPosition() : void
      {
         if (!f_objectsPositionInvalid)
         {
            f_objectsPositionInvalid = true;
            invalidateDisplayList();
         }
      }
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         _snapshotObjectsContainer.width = uw;
         _snapshotObjectsContainer.height = uh;
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
         if (f_objectsPositionInvalid)
         {
            grid.positionStaticObjects();
            squadronsController.repositionAllSquadrons();
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
      
      
      /**
       * User will use this to confirm or cancel orders. Shown when user clicks on a an empty space
       * and <code>GlobalFlags.issuingOrders</code> is <code>true</code>
       */
      internal var orderPopup:COrderPopup;
      
      
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
       * Creates popup components.
       * 
       * @param objectsContainer container you should add all popup objects to
       */
      protected function createPopupObjects(objectsContainer:Group) : void
      {
         orderSourceLocIndicator = new BitmapImage();
         orderSourceLocIndicator.visible = false;
         orderSourceLocIndicator.source =
            IMG.getImage(AssetNames.MOVEMENT_IMAGES_FOLDER + "order_from_indicator");
         objectsContainer.addElement(orderSourceLocIndicator);
         
         squadronsInfo = new CSquadronPopup();
         squadronsInfo.visible = false;
         objectsContainer.addElement(squadronsInfo);
         
         orderPopup = new COrderPopup();
         orderPopup.visible = false;
         objectsContainer.addElement(orderPopup);
         
         staticObjectsPopup = new CStaticSpaceObjectsPopup(customComponentClasses);
         staticObjectsPopup.visible = false;
         objectsContainer.addElement(staticObjectsPopup);
      }
      
      
      /* ################################ */
      /* ### USER GESTURES PROCESSING ### */
      /* ################################ */

      
      
      /**
       * Called when user click on an empty space. <code>CMapSpace</code> will cancel all selections
       * made by a user.
       */
      protected function emptySpace_clickHandler() : void
      {
         deselectSelectedObject();
         squadronsController.deselectSelectedSquadron();
         orderPopup.reset();
      }
      
      
      /**
       * Called when user clicks on <code>CSquadronsMapIcon</code> component. Delegates event
       * handling for <code>SquadronsController</code>.
       */
      protected function squadrons_clickHandler(component:CSquadronMapIcon) : void
      {
         squadronsController.selectSquadron(component);
      }
      
      
      /**
       * Called when user clicks on a static object. Calls <code>selectComponent()</code>
       * method.
       */
      protected function staticObject_clickHandler(object:Object) : void
      {
         selectComponent(object);
      }
      
      
      /* ############################### */
      /* ### STATIC OBJECT SELECTION ### */
      /* ############################### */
      
      
      private var _selectedStaticObject:CStaticSpaceObjectsAggregator;
      
      
      protected override function selectModel(model:BaseModel) : void
      {
         if (model is MStaticSpaceObjectsAggregator)
         {
            selectComponent(
               _staticObjectsCont.getElementAt
                  (getAggregatorComponentIndex(MStaticSpaceObjectsAggregator(model).currentLocation)),
               true
            );
         }
      }
      
      
      public override function selectComponent(component:Object, center:Boolean = false) : void
      {
         var staticObject:CStaticSpaceObjectsAggregator = CStaticSpaceObjectsAggregator(component);
         if (!staticObject.selected)
         {
            deselectSelectedObject();
            staticObjectsPopup.model = staticObject.model;
            staticObjectsPopup.visible = true;
            staticObjectsPopup.move(
               staticObject.x + staticObject.width,
               staticObject.y + staticObject.height
            );
            _selectedStaticObject = staticObject;
            _selectedStaticObject.selected = true;
            if (center)
            {
               viewport.moveContentTo(new Point(staticObject.x, staticObject.y), true);
            }
         }
         else if (staticObject.isNavigable)
         {
            staticObject.navigateTo();
         }
      }
      
      
      public override function deselectSelectedObject() : void
      {
         if (_selectedStaticObject)
         {
            staticObjectsPopup.model = null;
            staticObjectsPopup.visible = false;
            _selectedStaticObject.selected = false;
            _selectedStaticObject = null;
         }
      }
      
      
      protected override function zoomObjectImpl(object:*, operationCompleteHandler:Function = null) : void
      {
         if (object is MStaticSpaceObjectsAggregator)
         {
            var model:MStaticSpaceObjectsAggregator = MStaticSpaceObjectsAggregator(object);
            var component:CStaticSpaceObjectsAggregator = CStaticSpaceObjectsAggregator(
               _staticObjectsCont.getElementAt(getAggregatorComponentIndex(model.currentLocation))
            );
            viewport.zoomArea(
               new Rectangle(component.x, component.y, component.width, component.height),
               true, operationCompleteHandler
            );
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public override function getSnapshotComponent() : DisplayObject
      {
         return _snapshotObjectsContainer;
      }
      
      
      /**
       * Returns a list of static objects on the map.
       */
      public function getStaticObjects() : ArrayCollection
      {
         return DisplayListUtil.getChildren(_staticObjectsCont);
      }
      
      
      /**
       * Returns a list of route objects on the map.
       */
      public function getRouteObjects() : ArrayCollection
      {
         return DisplayListUtil.getChildren(routeObjectsCont);
      }
      
      
      /**
       * Returns list of <code>CSquadronsMapIcon</code> objects on the map.
       */
      public function getSquadronObjects() : ArrayCollection
      {
         return DisplayListUtil.getChildren(squadronObjectsCont);
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      protected override function addModelEventHandlers(model:MMap) : void
      {
         super.addModelEventHandlers(model);
         var map:MMapSpace = MMapSpace(model);
         map.addEventListener(MMapSpaceEvent.STATIC_OBJECTS_ADD, model_staticObjectsAdd);
         map.addEventListener(MMapSpaceEvent.STATIC_OBJECTS_REMOVE, model_staticObjectsRemove);
      }
      
      
      protected override function removeModelEventHandlers(model:MMap) : void
      {
         var map:MMapSpace = MMapSpace(model);
         map.removeEventListener(MMapSpaceEvent.STATIC_OBJECTS_ADD, model_staticObjectsAdd);
         map.removeEventListener(MMapSpaceEvent.STATIC_OBJECTS_REMOVE, model_staticObjectsRemove);
         super.removeModelEventHandlers(model);
      }
      
      
      private function model_staticObjectsAdd(event:MMapSpaceEvent) : void
      {
         createStaticObject(event.objectsAggregator);
         grid.positionStaticObjectInSector(event.objectsAggregator.currentLocation);
      }
      
      
      private function model_staticObjectsRemove(event:MMapSpaceEvent) : void
      {
         destroyStaticObject(event.objectsAggregator.currentLocation);
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.CLICK, this_clickHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
      }
      
      
      /**
       * <code>MouseEvent.CLICK</code> event handler. Distributes event handling for different
       * "sub-handlers" by the event target object type.
       */
      protected function this_clickHandler(event:MouseEvent) : void
      {
         // User clicked on a squadrons indicator
         if (event.target is CSquadronMapIcon)
         {
            emptySpace_clickHandler();
            squadrons_clickHandler(CSquadronMapIcon(event.target));
         }
         // User clicked on a static map object
         else if (event.target is CStaticSpaceObjectsAggregator)
         {
            if (!ORDERS_CTRL.issuingOrders)
            {
               orderPopup.reset();
            }
            squadronsController.deselectSelectedSquadron();
            staticObject_clickHandler(event.target);
         }
         // As no other types of objects are on the map, pass this event for grid
         else
         {
            if (!ORDERS_CTRL.issuingOrders)
            {
               deselectSelectedObject();
               orderPopup.reset();
            }
            squadronsController.deselectSelectedSquadron();
            grid.map_clickHandler(event);
         }
      }
      
      
      protected function this_mouseMoveHandler(event:MouseEvent) : void
      {
         grid.map_mouseMoveHandler(event);
      }
      
      
      /* ############################### */
      /* ### VIEWPORT EVENT HANDLERS ### */
      /* ############################### */
      
      
      private function addViewportEventHandlers(viewport:ViewportZoomable) : void
      {
         viewport.addEventListener(ViewportEvent.CLICK_EMPTY_SPACE, viewport_clickEmptySpaceHandler);
      }
      
      
      private function removeViewportEventHandlers(viewport:ViewportZoomable) : void
      {
         viewport.removeEventListener(ViewportEvent.CLICK_EMPTY_SPACE, viewport_clickEmptySpaceHandler);
      }
      
      
      private function viewport_clickEmptySpaceHandler(event:ViewportEvent) : void
      {
         emptySpace_clickHandler();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getAggregatorComponentIndex(location:LocationMinimal) : int
      {
         for (var i:int = 0; i < _staticObjectsCont.numElements; i++)
         {
            var component:CStaticSpaceObjectsAggregator =
               CStaticSpaceObjectsAggregator(_staticObjectsCont.getElementAt(i));
            if (component.currentLocation.equals(location))
            {
               return i;
            }
         }
         return -1;
      }
      
      
      private var _customComponentClasses:StaticObjectComponentClasses;
      private function get customComponentClasses() : StaticObjectComponentClasses
      {
         if (!_customComponentClasses)
         {
            _customComponentClasses = createCustomComponentClasses();
         }
         return _customComponentClasses;
      }
      
      
      /**
       * @throws IllegalOperationError
       */
      private function throwIllegalOperationError() : void
      {
         throw new IllegalOperationError("This method is abstract!");
      }
   }
}
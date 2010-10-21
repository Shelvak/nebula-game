package components.map.space
{
   import components.base.viewport.ViewportZoomable;
   import components.base.viewport.events.ViewportEvent;
   import components.map.CMap;
   import components.movement.COrderPopup;
   import components.movement.CSquadronMapIcon;
   import components.movement.CSquadronPopup;
   
   import ext.flex.mx.collections.ArrayCollection;
   
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import models.map.Map;
   
   import namespaces.map_internal;
   
   import spark.components.Group;
   
   import utils.components.DisplayListUtil;
   
   
   use namespace map_internal;
   
   
   public class CMapSpace extends CMap
   {
      internal var grid:Grid;
      internal var squadronsController:SquadronsController;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       */
      public function CMapSpace(model:Map)
      {
         super(model);
         addSelfEventHandlers();
      }
      
      
      /**
       * Creates concrete instance of <code>Grid</code> for use in a map. 
       */
      protected function createGrid() : void
      {
         throwIllegalOperationError();
      }
      
      
      protected override function getSize() : Point
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
         
         createGrid();
         addElement(grid);
         squadsLayout = new SquadronsLayout(this);
         
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
      
      
      /**
       * Override this to create static objects (these should be added to objects list) of
       * custom space map.
       * 
       * @param objectsContainer container you should add all background objects to
       */
      protected function createStaticObjects(objectsContainer:Group) : void
      {
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
            squadronsController.positionAllSquadrons();
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
       * Creates popup components.
       * 
       * @param objectsContainer container you should add all popup objects to
       */
      protected function createPopupObjects(objectsContainer:Group) : void
      {
         squadronsInfo = new CSquadronPopup();
         objectsContainer.addElement(squadronsInfo);
         
         orderPopup = new COrderPopup();
         objectsContainer.addElement(orderPopup);
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
         squadronsInfo.squadron = null;
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
         // First, cancel all selections
         emptySpace_clickHandler();
         // User clicked on a squadrons indicator
         if (event.target is CSquadronMapIcon)
         {
            squadrons_clickHandler(CSquadronMapIcon(event.target));
         }
         // User clicked on a static map object
         else if (event.target is IMapSpaceObject)
         {
            staticObject_clickHandler(event.target);
         }
         // As no other types of objects are on the map, pass this event for grid
         else
         {
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
      
      
      /**
       * @throws IllegalOperationError
       */
      private function throwIllegalOperationError() : void
      {
         throw new IllegalOperationError("This method is abstract!");
      }
   }
}
package components.map.space
{
   import com.developmentarc.core.datastructures.utils.HashTable;
   
   import components.base.viewport.ViewportZoomable;
   import components.base.viewport.events.ViewportEvent;
   import components.map.CMap;
   import components.movement.COrderPopup;
   import components.movement.CRoute;
   import components.movement.CSquadronsMapIcon;
   import components.movement.CSquadronsPopup;
   
   import controllers.units.SquadronsController;
   
   import ext.flex.mx.collections.ArrayCollection;
   
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import models.location.LocationMinimal;
   import models.map.Map;
   import models.map.events.MapEvent;
   import models.movement.MSquadron;
   import models.movement.events.MSquadronEvent;
   
   import namespaces.map_internal;
   
   import spark.components.Group;
   
   import utils.components.DisplayListUtil;
   
   
   use namespace map_internal;
   
   
   public class CMapSpace extends CMap
   {
      map_internal var grid:Grid;
      protected var squadronsController:SquadronsController;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       */
      public function CMapSpace(model:Map)
      {
         super(model);
         squadronsController = SquadronsController.getInstance();
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
            squadronsInfo.reset();
            squadronsController.resetSelectionState(this);
            deselectSelectedObject();
         }
         if (_routeObjectsCont)
         {
            for each (var route:CRoute in getRouteObjects())
            {
               removeSquadronEventHandlers(route.squadron);
               route.cleanup();
            }
            _routeObjectsCont = null;
            _routeObjectsHash = null;
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
      private var _routeObjectsCont:Group;
      /**
       * Hash of <code>CRoute</code> components where key is <code>component.model.hashKey()</code>
       * and <code>component.model.currentLocation.hashKey()</code>.
       */
      private var _routeObjectsHash:HashTable = new HashTable();
      
      
      /**
       * Squadrons that move (layer above route objects).
       */
      map_internal var squadronObjectsCont:Group;
      /**
       * Hash of <code>CSquadronsMapIcon</code> components where key is <code>component.model.hashKey()</code>
       * and <code>component.model.currentLocation.hashKey()</code> (value for this kind of key is a
       * collection of components since there can be up to 4 <code>CSquadronsMapIcon</code> components in
       * the same space sector).
       */
      private var _squadronObjectsHash:HashTable = new HashTable();
      
      
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
         
         popupsCont = new Group();
         popupsCont.mouseEnabled = false;
         addElement(popupsCont);
         createPopupObjects(popupsCont);
         
         _backgroundObjectsCont = createContainer();
         _backgroundObjectsCont.mouseChildren = false;
         createBackgroundObjects(_backgroundObjectsCont);
         
         _staticObjectsCont = createContainer();
         createStaticObjects(_staticObjectsCont);
         
         _routeObjectsCont = createContainer();
         
         squadronObjectsCont = createContainer();
         squadronsController.initializeCMapSquadrons(this);
         
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
         _routeObjectsCont.width = uw;
         _routeObjectsCont.height = uh;
         squadronObjectsCont.width = uw;
         squadronObjectsCont.height = uh;
         if (f_objectsPositionInvalid)
         {
            grid.positionStaticObjects();
            squadronsController.positionAllCSquadrons(this);
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
      map_internal var squadronsInfo:CSquadronsPopup;
      
      
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
         squadronsInfo = new CSquadronsPopup();
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
         squadronsInfo.reset();
         squadronsController.resetSelectionState(this);
         squadronsController.deselectSelectedCSquadrons();
         orderPopup.reset();
      }
      
      
      /**
       * Called when user clicks on <code>CSquadronsMapIcon</code> component. Delegates event
       * handling for <code>SquadronsController</code>.
       */
      protected function squadrons_clickHandler(component:CSquadronsMapIcon) : void
      {
         squadronsController.selectCSquadrons(this, component);
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
       * Returns <code>CRoute</code> component which represents route of the given squadron.
       * 
       * @param squadron a squadron to look route component for
       * 
       * @return <code>CRoute</code> representing given squadron or <code>null</code> if such
       * instance does not exist
       */
      public function getCRouteByModel(squadron:MSquadron) : CRoute
      {
         return _routeObjectsHash.getItem(squadron.hashKey());
      }
      
      
      /**
       * Returns a list of <code>CSquadronsMapIcon</code> components in the given space sector.
       * 
       * @param location space sector to look components in
       * 
       * @return a list of <code>CSquadronsMapIcon</code> components (up to 4) in the given sector or new
       * empty collection if no components can be found.
       */
      public function getCSquadronsByLocation(location:LocationMinimal) : ArrayCollection
      {
         if (_squadronObjectsHash.containsKey(location.hashKey()))
         {
            return _squadronObjectsHash.getItem(location.hashKey());
         }
         return new ArrayCollection();
      }
      
      
      /**
       * Returns <code>CSquadronsMapIcon</code> component that represents given squadron.
       * 
       * @param squadron a squadron model
       * 
       * @return either <code>CSquadronsMapIcon</code> component or <code>null</code> if the component
       * representing the given squadron could not be found
       */
      public function getCSquadronsByModel(squadron:MSquadron) : CSquadronsMapIcon
      {
         for each (var comp:CSquadronsMapIcon in getSquadronObjects())
         {
            if (comp.hasSquadron(squadron))
            {
               return comp;
            }
         }
         return null;
      }
      
      
      /**
       * Adds given <code>CSquadronsMapIcon</code> to display list and puts it into a hash (model must be
       * set and initialized completely).
       */
      public function addCSquadrons(component:CSquadronsMapIcon) : void
      {
         var list:ArrayCollection = getCSquadronsByLocation(component.currentLocation);
         if (list.isEmpty)
         {
            _squadronObjectsHash.addItem(component.currentLocation.hashKey(), list);
         }
         list.addItem(component);
         squadronObjectsCont.addElement(component);
      }
      
      
      /**
       * Removes given <code>CSquadronsMapIcon</code> from display list and from a hash.
       * 
       * @param component <code>CSquadronsMapIcon</code> instance to remove from the display list
       * @param location if specified, component will be removed from the
       * <code>location.hashKey()</code> rather than
       * <code>component.currentLocation.hashKey()</code> slot of the <code>CSquadronsMapIcon</code> hash.
       */
      public function removeCSquadrons(component:CSquadronsMapIcon, location:LocationMinimal = null) : void
      {
         if (!location)
         {
            location = component.currentLocation;
         }
         squadronObjectsCont.removeElement(component);
         var list:ArrayCollection = _squadronObjectsHash.getItem(location.hashKey());
         list.removeItem(component);
         if (list.isEmpty)
         {
            _squadronObjectsHash.remove(location.hashKey());
         }
      }
      
      
      /**
       * Adds given <code>CRoute</code> to display list and puts it into the hash (model must be set
       * and initialized completely).
       */
      map_internal function addCRoute(component:CRoute) : void
      {
         addSquadronEventHandlers(component.squadron);
         _routeObjectsCont.addElement(component);
         _routeObjectsHash.addItem(component.squadron.hashKey(), component);
      }
      
      
      /**
       * Removes given <code>CRoute</code> from display list and from a hash (model must be set and
       * initialized completely).
       */
      map_internal function removeCRoute(component:CRoute) : void
      {
         removeSquadronEventHandlers(component.squadron);
         _routeObjectsCont.removeElement(component);
         _routeObjectsHash.remove(component.squadron.hashKey());
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
         return DisplayListUtil.getChildren(_routeObjectsCont);
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
         if (event.target is CSquadronsMapIcon)
         {
            squadrons_clickHandler(CSquadronsMapIcon(event.target));
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
      
      
      /**
       * <code>MouseEvent.MOUSE_MOVE</code> event handler. Passes this event for <code>grid</code>.
       */
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
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      override protected function addModelEventHandlers(model:Map) : void
      {
         super.addModelEventHandlers(model);
         model.addEventListener(MapEvent.SQUADRON_ENTER, model_squadronEnterHandler);
         model.addEventListener(MapEvent.SQUADRON_LEAVE, model_squadronLeaveHandler);
      }
      
      
      override protected function removeModelEventHandlers(model:Map) : void
      {
         model.removeEventListener(MapEvent.SQUADRON_ENTER, model_squadronEnterHandler);
         model.removeEventListener(MapEvent.SQUADRON_LEAVE, model_squadronLeaveHandler);
         super.removeModelEventHandlers(model);
      }
      
      
      private function model_squadronEnterHandler(event:MapEvent) : void
      {
         squadronsController.createOrUpdateCSquadrons(this, event.squadron);
      }
      
      
      private function model_squadronLeaveHandler(event:MapEvent) : void
      {
         squadronsController.removeOrUpdateCSquadrons(this, event.squadron);
      }
      
      
      /* ############################### */
      /* ### SQUADRON EVENT HANDLERS ### */
      /* ############################### */
      
      
      private function addSquadronEventHandlers(squadron:MSquadron) : void
      {
         squadron.addEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
      }
      
      
      private function removeSquadronEventHandlers(squadron:MSquadron) : void
      {
         squadron.removeEventListener(MSquadronEvent.MOVE, squadron_moveHandler);
      }
      
      
      private function squadron_moveHandler(event:MSquadronEvent) : void
      {
         squadronsController.moveSquadron(this, event.squadron, event.moveFrom, event.moveTo);
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
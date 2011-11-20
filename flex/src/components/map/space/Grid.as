package components.map.space
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   
   import config.Config;
   
   import controllers.units.OrdersController;
   import controllers.units.events.OrdersControllerEvent;
   
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.map.IMStaticSpaceObject;
   import models.ModelsCollection;
   import models.location.LocationMinimal;
   import models.map.MMapSpace;
   
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   
   import spark.components.Group;
   import spark.layouts.VerticalLayout;
   
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.datastructures.Collections;
   
   
   public class Grid extends Group implements ICleanable
   {
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      private var _map:CMapSpace;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       * 
       * @param map a space map this grid is part of
       */
      public function Grid(map:CMapSpace)
      {
         Objects.paramNotNull("map", map);
         this._map = map;
         addOrdersControllerEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         removeOrdersControllerEventHandlers();
         if (sectorIndicator)
         {
            sectorIndicator.cleanup();
            sectorIndicator = null;
         }
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      /**
       * Component that visually represents a sector which is closest to the mouse. 
       */
      protected var sectorIndicator:AnimatedBitmap;
      
      
      protected override function createChildren () : void
      {
         super.createChildren();
         sectorIndicator = AnimatedBitmap.createInstance(
            ImagePreloader.getInstance().getFrames(AssetNames.MOVEMENT_IMAGES_FOLDER + "sector_indicator"),
            Config.getAssetValue("images.ui.movement.sectorIndicator.actions"),
            AnimationTimer.forMovement
         );
         sectorIndicator.playAnimation("spin");
         addElement(sectorIndicator);
         doSectorProximitySearch();
      }
      
      
      /* ################################################## */
      /* ### SECTOR PROXIMITY SEARCH AND ORDERS ISSUING ### */
      /* ################################################## */
      
      /**
       * Sector which is currently under the mouse. Is relevant and set if
       * <code>GlobalFlags.issuingOrders</code> is set to <code>true</code>.
       */
      protected var locationUnderMouse:LocationMinimal = null;
      
      
      private function doSectorProximitySearch() : void
      {
         if (!ORDERS_CTRL.issuingOrders)
         {
            sectorIndicator.visible = false;
            return;
         }
         var loc:LocationMinimal = getSectorLocation(new Point(mouseX, mouseY));
         // if we don't have sector close enough to mouse, just leave the old sector
         if (!loc)
         {
            return;
         }
         var coords:Point = getSectorRealCoordinates(loc);
         sectorIndicator.x = coords.x - sectorIndicator.width / 2;
         sectorIndicator.y = coords.y - sectorIndicator.width / 2;
         sectorIndicator.visible = true;
         locationUnderMouse = loc;
      }
      
      
      /**
       * Repositions map sector popups, updates target location and speed control popups. 
       * 
       * @param locationUnderMouse pass location if you need to use other location then the
       * location captured after the last click on the map.
       */
      internal function issueOrderToLocationUnderMouse(locationUnderMouse:LocationMinimal = null) : void
      {
         if (!sectorIndicator.visible)
            return;
         if (locationUnderMouse == null)
            locationUnderMouse = this.locationUnderMouse;
         else
            this.locationUnderMouse = locationUnderMouse;
         
         // Somehow a map which is cached but not currently visible sometimes gets to this point
         // and since it is not active, the call to getSectorRealCoordinates() bellow fails. So for now we
         // just ignore such calls as they seem to be very rare.
         if (locationUnderMouse == null)
            return;
         
         var position:Point = getSectorRealCoordinates(locationUnderMouse);
         _map.positionSectorPopups(position);
         var objectsAggregator:CStaticSpaceObjectsAggregator = getStaticObjectInSector(locationUnderMouse);
         var staticObject:IMStaticSpaceObject = objectsAggregator == null ?
            null :
            objectsAggregator.model.findObjectOfType(MMapSpace.STATIC_OBJECT_NATURAL);
         ORDERS_CTRL.updateTargetLocationPopup(locationUnderMouse, _map.targetLocationPopup, staticObject);
         if (_map.targetLocationPopup.visible)
         {
            VerticalLayout(_map.sectorPopups.layout).paddingTop = 0;
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Proxy to <code>mapModel.definesLocation()</code>.
       */
      public function definesLocation(location:LocationMinimal) : Boolean {
         return _map.getModel().definesLocation(location);
      }
      
      
      /**
       * Calculates and returns real map size in the screen.
       * 
       * @return A point where <code>x</code> holds width of a map and <code>y</code> -
       * height of a map
       */
      public function getRealMapSize() : Point
      {
         throwAbstractMethodError();
         return null;   // unreachable
      }
      
      
      /**
       * Calculates and returns real coordinates of the given sector on a map.
       * 
       * @param location a sector for which coordinates must be calculated
       *  
       * @return actual position of a sector in a map component 
       */
      public function getSectorRealCoordinates(location:LocationMinimal) : Point
      {
         throwAbstractMethodError();
         return null;   // unreachable
      }
      
      
      /**
       * Does the opposite thing than <code>getSectorRealCoordinates()</code>: takes real
       * coordinates of a sector and returns location model.
       * 
       * @param coordinates actual coordinates of a sector
       * 
       * @return location model which defines the given sector
       */
      public function getSectorLocation(coordinates:Point) : LocationMinimal
      {
         throwAbstractMethodError();
         return null;   // unreachable
      }
      
      
      /**
       * Positions static object in the given sector.
       * 
       * @param location sector of a map to reposition object in
       */
      public function positionStaticObjectInSector(location:LocationMinimal) : void
      {
         var sectorPosition:Point = getSectorRealCoordinates(location);
         var staticObject:IVisualElement = getStaticObjectInSector(location);
         if (staticObject)
         {
            staticObject.x = sectorPosition.x - staticObject.getLayoutBoundsWidth() / 2;
            staticObject.y = sectorPosition.y - staticObject.getLayoutBoundsHeight() / 2;
         }
      }
      
      
      /**
       * Positions all static objects on a map.
       */
      public function positionStaticObjects() : void
      {
         for each (var location:LocationMinimal in getAllSectors())
         {
            positionStaticObjectInSector(location);
         }
      }
      
      
      /**
       * Returns static objects in the given sector.
       * 
       * @param location <code>LocationMinimal</code> defining the sector
       * 
       * @return static object in the given sector or <code>null</code> if there
       * is no static object there
       */
      public function getStaticObjectInSector(location:LocationMinimal) : CStaticSpaceObjectsAggregator
      {
         var list:ArrayCollection = getObjectsInSector(location, _map.getStaticObjects());
         var object:CStaticSpaceObjectsAggregator =
            list.length != 0 ? CStaticSpaceObjectsAggregator(list.getItemAt(0)) : null;
         list.filterFunction = null;
         list.removeAll();
         return object; 
      }
      
      
      /**
       * Returns a list of all sectors (possible locations) in the map.
       */
      internal function getAllSectors() : ModelsCollection
      {
         throwAbstractMethodError();
         return null;   // unreachable
      }
      
      
      /* ################################## */
      /* ### GlobalFlags EVENT HANDLERS ### */
      /* ################################## */
      
      
      private function addOrdersControllerEventHandlers() : void
      {
         ORDERS_CTRL.addEventListener(OrdersControllerEvent.ISSUING_ORDERS_CHANGE,
                                      OrdersController_issuingOrdersChangeHandler, false, 0, true);
      }
      
      
      private function removeOrdersControllerEventHandlers() : void
      {
         ORDERS_CTRL.removeEventListener(OrdersControllerEvent.ISSUING_ORDERS_CHANGE,
                                         OrdersController_issuingOrdersChangeHandler, false);
      }
      
      
      private function OrdersController_issuingOrdersChangeHandler(event:OrdersControllerEvent) : void
      {
         doSectorProximitySearch();
         _map.deselectSelectedObject();
      }
      
      
      /* ################################ */
      /* ### MAP MOUSE EVENT HANDLERS ### */
      /* ################################ */
      
      
      /**
       * <code>MouseEvent.MOUSE_MOVE</code> event handler. Ivoked by <code>CMapSpace</code>.
       */
      internal function map_mouseMoveHandler(event:MouseEvent) : void
      {
         if (ORDERS_CTRL.issuingOrders)
         {
            doSectorProximitySearch();
         }
      }
      
      
      /**
       * <code>MouseEvent.CLICK</code> event handler. Ivoked by <code>CMapSpace</code>.
       */
      internal function map_clickHandler(event: MouseEvent): void {
         if (ORDERS_CTRL.issuingOrders) {
            doSectorProximitySearch();
            if (locationUnderMouse == null) {
               // we don't have sector close enough to the mouse pointer
               return;
            }
            var staticObject: * = getStaticObjectInSector(locationUnderMouse);
            if (staticObject) {
               _map.selectComponent(staticObject);
            }
            else {
               _map.deselectSelectedObject();
            }
            issueOrderToLocationUnderMouse();
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * @throws IllegalOperationError
       */
      private function throwAbstractMethodError() : void
      {
         throw new IllegalOperationError("This method is abstract!");
      }
      
      
      private function getObjectsInSector(location:LocationMinimal, list:ArrayCollection) : ArrayCollection
      {
         return Collections.applyFilter(list,
            function(item:CStaticSpaceObjectsAggregator) : Boolean
            { return item.currentLocation.equals(location) }
         );
      }
   }
}
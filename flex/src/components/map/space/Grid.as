package components.map.space
{
   import components.movement.COrderPopup;
   
   import controllers.GlobalFlags;
   import controllers.events.GlobalFlagsEvent;
   import controllers.units.OrdersController;
   
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import models.ModelsCollection;
   import models.location.LocationMinimal;
   
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   import mx.graphics.SolidColor;
   
   import spark.components.Group;
   import spark.primitives.Ellipse;
   
   import utils.ClassUtil;

   public class Grid extends Group implements ICleanable
   {
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
         ClassUtil.checkIfParamNotNull("map", map);
         this._map = map;
         addGlobalFlagsEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         removeGlobalFlagsEventHandlers();
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      /**
       * Component that visually represents a sector which is closest to the mouse. 
       */
      private var _sectorIndicator:Ellipse;
      private function updateSectorIndicatorVisibility() : void
      {
         _sectorIndicator.visible = GlobalFlags.getInstance().issuingOrders;
      }
      
      
      
      protected override function createChildren () : void
      {
         super.createChildren();
         _sectorIndicator = new Ellipse();
         _sectorIndicator.width = _sectorIndicator.height = 24;
         _sectorIndicator.fill = new SolidColor(0xFFFFFF);
         updateSectorIndicatorVisibility();
         addElement(_sectorIndicator);
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
         var loc:LocationMinimal = getSectorLocation(new Point(mouseX, mouseY));
         // If we don't have sector close enough to mouse, just leave the old sector
         if (!loc)
         {
            return;
         }
         var coords:Point = getSectorRealCoordinates(loc);
         _sectorIndicator.x = coords.x - _sectorIndicator.width / 2;
         _sectorIndicator.y = coords.y - _sectorIndicator.width / 2;
         locationUnderMouse = loc;
      }
      
      
      protected function issueOrderToLocationUnderMouse() : void
      {
         var popup:COrderPopup = _map.orderPopup;
         var position:Point = getSectorRealCoordinates(locationUnderMouse);
         popup.x = position.x;
         popup.y = position.y;
         var staticObject:* = getStaticObjectInSector(locationUnderMouse);
         OrdersController.getInstance().updateOrderPopup(locationUnderMouse, popup, staticObject ? staticObject.model : null);
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
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
      protected function positionStaticObjectInSector(location:LocationMinimal) : void
      {
         var sectorPosition:Point = getSectorRealCoordinates(location);
         var staticObject:IVisualElement = getStaticObjectInSector(location);
         if (staticObject)
         {
            staticObject.x = sectorPosition.x - staticObject.width / 2;
            staticObject.y = sectorPosition.y - staticObject.height / 2;
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
      public function getStaticObjectInSector(location:LocationMinimal) : IVisualElement
      {
         var list:ArrayCollection = getObjectsInSector(location, _map.getStaticObjects());
         return list.length != 0 ? IVisualElement(list.getItemAt(0)) : null;
      }
      
      
      /**
       * Returns a list of all sectors (possible locations) in the map.
       */
      protected function getAllSectors() : ModelsCollection
      {
         throwAbstractMethodError();
         return null;   // unreachable
      }
      
      
      /* ################################## */
      /* ### GlobalFlags EVENT HANDLERS ### */
      /* ################################## */
      
      
      private function addGlobalFlagsEventHandlers() : void
      {
         GlobalFlags.getInstance().addEventListener
            (GlobalFlagsEvent.ISSUING_ORDERS_CHANGE, GlobalFlags_issuingOrdersChangeHandler);
      }
      
      
      private function removeGlobalFlagsEventHandlers() : void
      {
         GlobalFlags.getInstance().removeEventListener
            (GlobalFlagsEvent.ISSUING_ORDERS_CHANGE, GlobalFlags_issuingOrdersChangeHandler);
      }
      
      
      private function GlobalFlags_issuingOrdersChangeHandler(event:GlobalFlagsEvent) : void
      {
         updateSectorIndicatorVisibility();
      }
      
      
      /* ################################ */
      /* ### MAP MOUSE EVENT HANDLERS ### */
      /* ################################ */
      
      
      /**
       * <code>MouseEvent.MOUSE_MOVE</code> event handler. Ivoked by <code>CMapSpace</code>.
       */
      internal function map_mouseMoveHandler(event:MouseEvent) : void
      {
         if (GlobalFlags.getInstance().issuingOrders)
         {
            doSectorProximitySearch();
         }
      }
      
      
      /**
       * <code>MouseEvent.CLICK</code> event handler. Ivoked by <code>CMapSpace</code>.
       */
      internal function map_clickHandler(event:MouseEvent) : void
      {
         if (GlobalFlags.getInstance().issuingOrders)
         {
            doSectorProximitySearch();
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
         list.filterFunction = function(item:IMapSpaceObject) : Boolean
         {
            return item.currentLocation.equals(location);
         };
         list.refresh();
         return list;
      }
   }
}
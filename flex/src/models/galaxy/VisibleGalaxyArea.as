package models.galaxy
{
   import components.base.viewport.IVisibleAreaTrackerClient;
   import components.map.space.GalaxyMapCoordsTransform;
   import components.map.space.IVisibleGalaxyAreaClient;
   
   import flash.geom.Rectangle;
   
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MapArea;
   
   import utils.Objects;
   
   
   public class VisibleGalaxyArea implements IVisibleAreaTrackerClient
   {
      private var _galaxy:Galaxy;
      private var _client:IVisibleGalaxyAreaClient;
      private var _coordsTransform:GalaxyMapCoordsTransform;
      
      /**
       * @param model galaxy model | <b>not null</b>
       * @param client on object that will be notified of visible area changes
       *        | <b>not null</b>
       * @param coordsTransform used to transform from screen coodrinates to logical map coordinates
       *        | <b>not null</b>
       */
      public function VisibleGalaxyArea(model:Galaxy,
                                        client:IVisibleGalaxyAreaClient,
                                        coordsTransform:GalaxyMapCoordsTransform) {
         _galaxy = Objects.paramNotNull("model", model);
         _client = Objects.paramNotNull("client", client);
         _coordsTransform = Objects.paramNotNull("coordsTransform", coordsTransform);
         _galaxyLoc = new LocationMinimal();
         _galaxyLoc.type = LocationType.GALAXY;
         _galaxyLoc.id = _galaxy.id;
      }
      
      private var _visibleAreaOld:MapArea;
      private var _visibleArea:MapArea
      /**
       * Visible area of a galaxy in its logical coordinates. If nothing is visible,
       * this is <code>null</code>.
       */
      public function get visibleArea() : MapArea {
         return _visibleArea;
      }
      
      
      /* ################################# */
      /* ### IVisibleAreaTrackerClient ### */
      /* ################################# */
      
      public function visibleAreaChange(visibleAreaReal:Rectangle,
                                        hiddenAreas:Vector.<Rectangle>,
                                        shownAreas:Vector.<Rectangle>) : void {
         Objects.paramNotNull("visibleAreaReal", visibleAreaReal);
         Objects.paramNotNull("hiddenAreas", hiddenAreas);
         Objects.paramNotNull("shownAreas", shownAreas);
         _visibleAreaOld = _visibleArea;
         if (visibleAreaReal.width > 0 && visibleAreaReal.height > 0) {
            _visibleArea = realToLogicalArea(visibleAreaReal);
         }
         else {
            _visibleArea = null
         }
         for each (var hiddenAreaReal:Rectangle in hiddenAreas) {
            forEachSector(realToLogicalArea(hiddenAreaReal), callSectorHidden);
         }
         for each (var shownAreaReal:Rectangle in shownAreas) {
            forEachSector(realToLogicalArea(shownAreaReal), callSectorShown);
         }
      }
      
      private function callSectorHidden(x:int, y:int) : void {
         if (shouldTouchSector(_visibleArea, x, y)) {
            _client.sectorHidden(x, y);
         }
      }
      
      private function callSectorShown(x:int, y:int) : void {
         if (shouldTouchSector(_visibleAreaOld, x, y)) {
            _client.sectorShown(x, y);
         }
      }
      
      /**
       * Should a sector defined by <code>x</code> and <code>y</code> coordinates and not contained
       * within <code>area</code> must have <code>client.areaShown()</code> or
       * <code>client.areaHidden()</code> invoked? 
       */
      private function shouldTouchSector(visibleArea:MapArea, x:int, y:int) : Boolean {
         // visibleArea does not contain (x, y})
         // AND
         // (x, y) is visible in galaxy OR there is a static object at (x, y)
         return ( visibleArea == null
                  || !visibleArea.contains(x, y) )
                &&
                ( _galaxy.locationIsVisible(getLocation(x, y))
                  || _galaxy.getSSAt(x, y) != null );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function forEachSector(area:MapArea, callback:Function) : void {
         for (var x:int = area.xMin; x <= area.xMax; x++) {
            for (var y:int = area.yMin; y <= area.yMax; y++) {
               callback.call(null, x, y);
            }
         }
      }
      
      private var _galaxyLoc:LocationMinimal;
      private function getLocation(x:int, y:int) : LocationMinimal {
         _galaxyLoc.x = x;
         _galaxyLoc.y = y;
         return _galaxyLoc;
      }
      
      private function realToLogicalArea(area:Rectangle) : MapArea {
         var bounds:MapArea = _galaxy.visibleBounds;
         return new MapArea(
            Math.max(bounds.xMin, _coordsTransform.realToLogical_X(area.left, 0)),
            Math.min(bounds.xMax, _coordsTransform.realToLogical_X(area.right - 1, 0)),
            Math.max(bounds.yMin, _coordsTransform.realToLogical_Y(0, area.bottom)),
            Math.min(bounds.yMax, _coordsTransform.realToLogical_Y(0, area.top + 1))
         );
      }
   }
}


//import flash.geom.Point;
//import flash.utils.Dictionary;
//
//
//class SectorHash
//{
//   private const _hash:Dictionary = new Dictionary();
//   
//   public function SectorHash() {
//   }
//   
//   public function add(sector:Point) : void {
//      if (!has(sector)) {
//         _hash[computeHashCode(sector)] = sector;
//      }
//   }
//   
//   public function remove(sector:Point) : void {
//      if (has(sector)) {
//         delete _hash[computeHashCode(sector)];
//      }
//   }
//   
//   public function has(sector:Point) : Boolean {
//      return _hash[computeHashCode(sector)] != null;
//   }
//   
//   public function getAll() : Vector.<Point> {
//      var sectors:Vector.<Point> = new Vector.<Point>();
//      for each (var sector:Point in _hash) {
//         sectors.push(sector);
//      }
//      return sectors;
//   }
//   
//   public function clone() : SectorHash {
//      var sectorHash:SectorHash = new SectorHash();
//      for each (var sector:Point in _hash) {
//         sectorHash.add(sector);
//      }
//      return sectorHash;
//   }
//   
//   private function computeHashCode(sector:Point) : int {
//      return sector.x * 100000 + sector.y;
//   }
//}
package globalevents
{
   import models.building.Building;
   
   
   public class GBuildingMoveEvent extends GBuildingEvent
   {
      /**
       * This is dispatched when user moves a building (which is about to
       * be constructed or moved to another place) around the map.
       * 
       * @eventType GBuildingMoveEvent_move 
       */
      public static const MOVE:String = "GBuildingMoveEvent_move";
      
      
      private var _tilesUnder:Array;
      /**
       * List of tiles under the building. Elements of the array are integers
       * from <code>TileKind</code> class.
       */
      public function get tilesUnder() : Array
      {
         return _tilesUnder;
      }
      
      
      public function GBuildingMoveEvent(type:String,
                                         tilesUnder:Array,
                                         b:Building,
                                         eagerDispatch:Boolean = true)
      {
         _tilesUnder = tilesUnder;
         super(type, b, 0, eagerDispatch);
      }
   }
}
package globalevents
{
   import models.building.Building;
   
   
   public class GBuildingMoveEvent extends GBuildingEvent
   {
      /**
       * This is dispatced when user moves a building that is about to
       * be constructed around the map.
       * 
       * @eventType newBuildingMove 
       */
      public static const MOVE:String = "newBuildingMove";
      
      
      private var _tilesUnder:Array;
      /**
       * List of tiles under the building. Elements of the array are integers
       * from <code>TileKind</code> class.
       */      
      public function get tilesUnder() : Array
      {
         return _tilesUnder;
      }
      
      /**
       * Constructor. 
       */
      public function GBuildingMoveEvent
         (type:String, tilesUnder:Array, b:Building, eagerDispatch:Boolean=true)
      {
         _tilesUnder = tilesUnder;
         super(type, b, 0, eagerDispatch);
      }
   }
}
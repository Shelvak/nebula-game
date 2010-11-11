package globalevents
{
   import models.BaseModel;
   import models.map.Map;

   /**
    * Commands (events) for map.
    */
   public class GMapEvent extends GlobalEvent
   {
      /**
       * Dispatch this to force currently displayed map to select an object.
       * 
       * @eventType selectMapObject
       */
      public static const SELECT_OBJECT:String = "selectMapObject";
      
      
      private var _map:Map = null;
      /**
       * Model of a map in which the given object should be selected.
       */
      public function get map() : Map
      {
         return _map;
      }
      
      
      private var _object:BaseModel = null;
      /**
       * An object that should be selected when <code>SELECT_OBJECT</code>
       * event has been dispatched.
       */
      public function get object() : BaseModel
      {
         return _object;
      }
      
      
      public function GMapEvent(type:String, object:BaseModel = null, map:Map = null, eagerDispatch:Boolean = true)
      {
         _map = map;
         _object = object;
         super(type, eagerDispatch);
      }
   }
}
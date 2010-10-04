package components.map.controllers
{
   import globalevents.GMapEvent;
   
   import models.BaseModel;
   import models.map.Map;
   import models.map.events.MapEvent;
   
   import spark.components.List;
   
   public class MapObjectsList extends List
   {
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _oldMap:Map = null;
      private var _map:Map = null;
      /**
       * A map that contains a list of objects to be displayed.
       */
      public function set map(value:Map) : void
      {
         if (_map != value)
         {
            _map = value;
         }
      }
      /**
       * @private
       */
      public function get map() : Map
      {
         return _map;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      protected override function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index, selected);
         if (selected && index >= 0)
         {
            dispatchSelectMapObjectEvent(dataProvider.getItemAt(index) as BaseModel);
            selectedIndex = -1;
         }
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchSelectMapObjectEvent(object:BaseModel) : void
      {
         new GMapEvent(GMapEvent.SELECT_OBJECT, map, object);
      }
   }
}
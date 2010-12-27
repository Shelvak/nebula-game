package models.map.events
{
   import flash.events.Event;
   
   import models.IStaticSpaceSectorObject;
   import models.StaticSpaceObjectsAggregator;
   
   public class MMapSpaceEvent extends Event
   {
      /**
       * @see models.map.MMapSpace
       * @eventType staticObjectsAdd
       */
      public static const STATIC_OBJECTS_ADD:String = "staticObjectsAdd";
      
      
      /**
       * @see models.map.MMapSpace
       * @eventType staticObjectsRemove
       */
      public static const STATIC_OBJECTS_REMOVE:String = "staticObjectsRemove";
      
      
      /**
       * @see models.map.MMapSpace
       * @eventType staticObjectsChange
       */
      public static const STATIC_OBJECTS_CHANGE:String = "staticObjectsChange";
      
      
      public function MMapSpaceEvent(type:String)
      {
         super(type, false, false);
      }
      
      
      /**
       * Aggregator of static space objects related to the event.
       */
      public var objectsAggregator:StaticSpaceObjectsAggregator;
      
      
      /**
       * Relevant only for <code>STATIC_OBJECTS_CHANGE</code> event.
       */
      public var object:IStaticSpaceSectorObject;
      
      
      /**
       * Kind of <code>STATIC_OBJECTS_CHANGE</code> event. Use constants from <code>MMapSpaceEventKind</code>
       * class.
       */
      public var kind:int;
   }
}
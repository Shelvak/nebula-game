package models.map.events
{
   import flash.events.Event;
   
   import models.map.MMap;
   import models.movement.MSquadron;
   
   
   public class MMapEvent extends Event
   {
      public static const UICMD_ZOOM_OBJECT:String = "uicmdZoomObject";
      public static const UICMD_SELECT_OBJECT:String = "uicmdSelectObject";
      
      
      /**
       * Dispatched when <code>objects</code> property is set to a new
       * collection.
       */
      public static const OBJECTS_LIST_CHANGE:String = "mapObjectsListChange";
      
      /**
       * Dispatched when a squadron enters (is added to) a map.
       * 
       * @eventType squadronEnter
       */
      public static const SQUADRON_ENTER:String = "squadronEnter";
      
      /**
       * Dispatched when a squadron leaves (is removed from) a map. 
       * 
       * @eventType squadronLeave
       */
      public static const SQUADRON_LEAVE:String = "squadronLeave";
      
      
      /**
       * Typed alias of <code>target</code> property.
       */
      public function get map() : MMap
      {
         return target as MMap;
      }
      
      
      public function MMapEvent(type:String)
      {
         super(type, false, false);
      }
      
      
      /**
       * Relevant only for <code>UICMD_*</code> events.
       */
      public var object:*;
      
      
      /**
       * Relevant only for <code>UICMD_*</code> events. Optional. Must not have any arguments.
       */
      public var operationCompleteHandler:Function;
      
      
      /**
       * A squadron which has entered (has been added to) or left (has been removed from) a map.
       * Makes sense only for <code>SQUADRON_ENTER</code> and <code>SQUADRON_LEAVE</code> events.
       */
      public var squadron:MSquadron;
   }
}
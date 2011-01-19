package models.map.events
{
   import flash.events.Event;
   
   import models.map.MMap;
   import models.movement.MSquadron;
   
   
   public class MMapEvent extends Event
   {
      /**
       * @see MMap
       * 
       * @eventType uicmdZoomObject
       */
      public static const UICMD_ZOOM_OBJECT:String = "uicmdZoomObject";
      
      
      /**
       * @see MMap
       * 
       * @eventType uicmdSelectObject
       */
      public static const UICMD_SELECT_OBJECT:String = "uicmdSelectObject";
      
      
      /**
       * @see MMap
       * 
       * @eventType squadronEnter
       */
      public static const SQUADRON_ENTER:String = "squadronEnter";
      
      
      /**
       * @see MMap
       * 
       * @eventType squadronLeave
       */
      public static const SQUADRON_LEAVE:String = "squadronLeave";
      
      
      /**
       * @see MMap
       * 
       * @eventType staticObjectAdd
       */
      public static const OBJECT_ADD:String = "staticObjectAdd";
      
      
      /**
       * @see MMap
       * 
       * @eventType staticObjectRemove
       */
      public static const OBJECT_REMOVE:String = "staticObjectRemove";
      
      
      public function MMapEvent(type:String)
      {
         super(type, false, false);
      }
      
      
      /**
       * Typed alias of <code>target</code> property.
       */
      public function get map() : MMap
      {
         return target as MMap;
      }
      
      
      /**
       * Relevant only for <code>UICMD_*</code> and <code>OBJECT_*</code> events.
       */
      public var object:*;
      
      
      /**
       * Relevant only for <code>UICMD_*</code> events. Optional. Must not have any arguments.
       */
      public var operationCompleteHandler:Function;
      
      
      /**
       * Relevant only for <code>SQUADRON_ENTER</code> and <code>SQUADRON_LEAVE</code> events.
       */
      public var squadron:MSquadron;
   }
}
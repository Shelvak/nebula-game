package models.map.events
{
   import flash.events.Event;

   import models.map.MMap;
   import models.movement.MSquadron;


   public class MMapEvent extends Event
   {
      /**
       * @see MMap
       */
      public static const UICMD_ZOOM_LOCATION: String = "uicmdZoomLocation";

      /**
       * @see MMap
       */
      public static const UICMD_SELECT_LOCATION: String = "uicmdSelectLocation";

      /**
       * @see MMap
       */
      public static const UICMD_DESELECT_SELECTED_LOCATION: String = "uicmdDeselectSelectedLocation";

      /**
       * @see MMap
       */
      public static const UICMD_MOVE_TO_LOCATION: String = "uicmdMoveToLocation";

      /**
       * @see MMap
       */
      public static const SQUADRON_ENTER: String = "squadronEnter";

      /**
       * @see MMap
       */
      public static const SQUADRON_LEAVE: String = "squadronLeave";

      /**
       *@see MMapSpace
       */
      public static const SQUADRON_MOVE: String = "squadronMove";

      /**
       * @see MMap
       */
      public static const OBJECT_ADD: String = "objectAdd";

      /**
       * @see MMap
       */
      public static const OBJECT_REMOVE: String = "objectRemove";

      public function MMapEvent(type: String) {
         super(type);
      }

      /**
       * Typed alias of <code>target</code> property.
       */
      public function get map(): MMap {
         return target as MMap;
      }

      /**
       * Relevant only for <code>UICMD_*</code> and <code>OBJECT_*</code> events.
       * for <code>UICMD_DESELECT_SELECTED_LOCATION</code> this will be
       * <code>null</code>.
       */
      public var object: *;

      /**
       * Should <code>UICMD_*</code> command be executed instantly (without animations if any)?
       *
       * @default false
       */
      public var instant: Boolean = false;

      /**
       * Relevant only for <code>UICMD_SELECT_LOCATION</code>. If
       * <code>true</code> will open a navigable static object in the location
       * defined by <code>object</code> if such objects is in this location.
       *
       * @default false
       */
      public var openOnSecondCall: Boolean = false;

      /**
       * Relevant only for <code>UICMD_*</code> events. Optional. Must not have any arguments.
       */
      public var operationCompleteHandler: Function;

      /**
       * Relevant only for <code>SQUADRON_*</code> events.
       */
      public var squadron: MSquadron;
   }
}
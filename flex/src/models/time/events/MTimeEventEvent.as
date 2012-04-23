package models.time.events
{
   import flash.events.Event;


   public class MTimeEventEvent extends Event
   {
      /**
       * Dispatched when <code>models.time.IMTimeEvent.hasOccurred</code> property changes.
       *
       * @eventType hasOccurredChange
       *
       * @see models.time.IMTimeEvent#hasOccurred
       */
      public static const HAS_OCCURRED_CHANGE: String = "hasOccurredChange";

      /**
       * Dispatched when <code>models.time.IMTimeEvent.occursIn</code>
       * property changes.
       *
       * @eventType occursInChange
       *
       * @see models.time.IMTimeEvent#occursIn
       */
      public static const OCCURS_IN_CHANGE: String = "occursInChange";

      /**
       * Dispatched when <code>models.time.IMTimeEvent.occursAt</code> property
       * changes.
       *
       * @eventType occursAtChange
       *
       * @see models.time.IMTimeEvent#occursAt
       */
      public static const OCCURS_AT_CHANGE: String = "occursAtChange";

      /**
       * Dispatched when
       * <code>models.time.MTimeEventFixedMoment.occurredBefore</code> property
       * changes.
       *
       * @eventType occurredBeforeChange
       *
       * @see models.time.MTimeEventFixedMoment#occurredBefore
       */
      public static const OCCURRED_BEFORE_CHANGE: String = "occurredBeforeChange";

      public function MTimeEventEvent(type: String) {
         super(type);
      }
   }
}
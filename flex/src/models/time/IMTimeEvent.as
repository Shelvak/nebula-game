package models.time
{
   import flash.events.IEventDispatcher;

   import interfaces.IEqualsComparable;
   import interfaces.IUpdatable;


   [Event(name="hasOccurredChange", type="models.time.events.MTimeEventEvent")]
   [Event(name="occursInChange", type="models.time.events.MTimeEventEvent")]
   [Event(name="occursAtChange", type="models.time.events.MTimeEventEvent")]
   
   
   /**
    * Interface of a time event. There are two kinds of time events:
    * <code>MTimeEventFixedInterval</code> and <code>MTimeEventFixedTime</code>.
    * See documentation of these classes for more information.
    */
   public interface IMTimeEvent extends IEqualsComparable,
                                        IUpdatable,
                                        IEventDispatcher
   {
      /**
       * Returns <code>true</code> if this event has already occurred or
       * <code>false</code> otherwise. Is <code>true</code> only when
       * <code>occursIn == 0</code>.
       * When this property changes
       * <code>models.time.events.MTimeEventEvent.HAS_OCCURRED_CHANGE</code>
       * event is dispatched.
       */
      function get hasOccurred() : Boolean;
      
      /**
       * Number of seconds that this event will occur after. Always greater or
       * equal to 0. When this property changes
       * <code>models.time.event.MTimeEventEvent.OCCURS_IN_CHANGE</code> event
       * is dispatched.
       */
      function get occursIn() : Number;
      
      /**
       * Shortcut for <code>DateUtil.secondsToHumanString(this.occursIn)</code>.
       */
      function occursInString(timeParts: int = 2): String;
      
      /**
       * Point in time when this event will occur (or already has occurred).
       * When this property changes
       * <code>models.time.event.MTimeEventEvent.OCCURS_AT_CHANGE</code> event
       * is dispatched.
       * Default is <code>null</code>.
       */
      function get occursAt() : Date;
      
      /**
       * Shortcut for <code>DateUtil.formatShortDateTime(this.occursAt)</code>.
       */
      function occursAtString(includeSeconds: Boolean = false): String;

      /**
       * Returns <code>true</code> if this instance of <code>IMTimeEvent</code>
       * defines a moment in time before the given one.
       *
       * @param event | <b>not null</b>
       */
      function before(event: IMTimeEvent, epsilon: Number = 0): Boolean;

      /**
       * Returns <code>true</code> if this instance of <code>IMTimeEvent</code>
       * defines a moment in time after the given one.
       *
       * @param event | <b>not null</b>
       */
      function after(event: IMTimeEvent, epsilon: Number = 0): Boolean;

      /**
       * Returns <code>true</code> if this instance of <code>IMTimeEvent</code>
       * defines the same moment in time as the given one.
       *
       * @param event | <b>not null</b>
       */
      function sameTime(event: IMTimeEvent, epsilon: Number = 0): Boolean;
   }
}
package models.time
{
   import flash.events.IEventDispatcher;
   
   import interfaces.IEqualsComparable;
   import interfaces.IUpdatable;
   
   
   /**
    * @see models.time.events.MTimeEventEvent#HAS_OCCURED_CHANGE
    * @eventType models.time.events.MTimeEventEvent.HAS_OCCURED_CHANGE
    */
   [Event(name="hasOccuredChange", type="models.time.events.MTimeEventEvent")]
   
   
   /**
    * @see models.time.events.MTimeEventEvent#OCCURES_IN_CHANGE
    * @eventType models.time.events.MTimeEventEvent.OCCURES_IN_CHANGE
    */
   [Event(name="occuresInChange", type="models.time.events.MTimeEventEvent")]
   
   
   /**
    * @see models.time.events.MTimeEventEvent#OCCURES_AT_CHANGE
    * @eventType models.time.events.MTimeEventEvent.OCCURES_AT_CHANGE
    */
   [Event(name="occuresAtChange", type="models.time.events.MTimeEventEvent")]
   
   
   /**
    * Interface of a time event. There are two kinds of time events: <code>MTimeEventFixedInterval</code>
    * and <code>MTimeEventFixedTime</code>. See documentation of these classes for more information. 
    */
   public interface IMTimeEvent extends IEqualsComparable, IUpdatable, IEventDispatcher
   {
      /**
       * Returns <code>true</code> if this event has already occured or <code>false</code> otherwise.
       * Is <code>true</code> only when <code>occuresIn == 0</code>.
       * When this property changes <code>models.time.events.MTimeEventEvent.HAS_OCCURED_CHANGE</code>
       * event is dispatched.
       */
      function get hasOccured() : Boolean;
      
      /**
       * Number of seconds that this event will occure after. Always greater or equal to 0. When this
       * property changes <code>models.time.event.MTimeEventEvent.OCCURES_IN_CHANGE</code> event is dispatched.
       */
      function get occuresIn() : Number;
      
      /**
       * Shortcut for <code>DateUtil.secondsToHumanString(this.occuresIn)</code>.
       */ 
      function get occuresInString() : String;
      
      /**
       * Point in time when this event will occure (or already has occured). When this property changes
       * <code>models.time.event.MTimeEventEvent.OCCURES_AT_CHANGE</code> event is dispatched. Default is
       * <code>null</code>. 
       */
      function get occuresAt() : Date;
      
      /**
       * Shortcut for <code>this.occuresAt.toString()</code>.
       */
      function get occuresAtString() : String;
   }
}
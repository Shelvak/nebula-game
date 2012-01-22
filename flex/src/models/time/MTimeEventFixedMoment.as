package models.time
{
   import models.time.events.MTimeEventEvent;

   import namespaces.change_flag;

   import utils.DateUtil;
   import utils.Objects;


   [Event(name="occuredBefore", type="models.time.events.MTimeEventEvent")]

   /**
    * Marks a fixed moment in time.
    * 
    * <p>You set <code>occuresAt</code> to some <code>Date</code>
    * (<code>null</code> is not allowed) and this values remains the same
    * until you set it again. Meanwhile <code>occuresIn</code> and
    * <code>occurredBefore</code> is updated when time advances.
    */
   public class MTimeEventFixedMoment extends MTimeEvent
   {
      /**
       * Type processor function for <code>Objects</code>.
       */
      public static function autoCreate(currValue:MTimeEventFixedMoment,
                                        value:String) : MTimeEventFixedMoment {
         var event:MTimeEventFixedMoment = null;
         event = currValue != null ? currValue : new MTimeEventFixedMoment();
         event.occuresAt = DateUtil.parseServerDTF(value);
         return event;
      }
      
      
      public function MTimeEventFixedMoment()
      {
         super();
      }
      
      
      /* ################### */
      /* ### IMTimeEvent ### */
      /* ################### */
      
      
      [Bindable(event="occuresInChange")]
      public override function get occuresIn() : Number
      {
         var diff:Number = _occuresAt.time - DateUtil.now;
         return diff < 0 ? 0 : Math.floor(diff / 1000);
      }
      
      
      private var _occuresAt:Date = new Date(0);
      [Bindable(event="occuresAtChange")]
      /**
       * A fixed moment in time.  This property does not change over time but <code>occuresIn</code> and
       * <code>hasOccured</code> does. You can't set this property to <code>null</code>: error will be thrown.
       * 
       * @see #occuresIn
       * @see #hasOccured
       */
      public function set occuresAt(value:Date) : void
      {
         Objects.paramNotNull("value", value);
         if (_occuresAt != value)
         {
            _occuresAt = value;
            occuresAtUpdated();
            occuresInUpdated();
            hasOccuredUpdated();
            occuredBeforeUpdated();
            _hasOccuredDispatched = false;
         }
      }
      /**
       * @private
       */
      public override function get occuresAt() : Date
      {
         return _occuresAt;
      }
      
      
      [Bindable(event="hasOccuredChange")]
      public override function get hasOccured() : Boolean
      {
         return _occuresAt.time <= DateUtil.now;
      }

      change_flag var occuredBefore: Boolean = true;
      /**
       * Number of seconds the event has occurred before or 0 if event has not
       * yet occurred.
       */
      [Bindable(event="occuredBeforeChange")]
      public function get occurredBefore(): Number {
         var diff:Number = DateUtil.now - _occuresAt.time;
         return diff < 0 ? 0 : Math.floor(diff / 1000);
      }

      [Bindable(event="occuredBeforeChange")]
      public function get occurredBeforeString(): String {
         return DateUtil.secondsToHumanString(occurredBefore, 2);
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */
      
      
      private var _hasOccuredDispatched:Boolean = false;
      
      
      public override function update() : void
      {
         if (!hasOccured) {
            occuresInUpdated();
         }
         if (!_hasOccuredDispatched && hasOccured) {
            _hasOccuredDispatched = true;
            hasOccuredUpdated();
            occuresInUpdated();
         }
         if (_occuresAt.time <= DateUtil.now) {
            occuredBeforeUpdated();
         }
      }

      public override function resetChangeFlags(): void {
         super.resetChangeFlags();
         change_flag::occuredBefore = false;
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function occuredBeforeUpdated(): void {
         change_flag::occuredBefore = true;
         dispatchSimpleEvent(
            MTimeEventEvent,
            MTimeEventEvent.OCCURRED_BEFORE_CHANGE
         );
      }
   }
}
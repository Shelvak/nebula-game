package models.time
{
   import flash.events.EventDispatcher;

   import models.time.events.MTimeEventEvent;

   import namespaces.change_flag;

   import utils.DateUtil;
   import utils.Events;
   import utils.NumberUtil;
   import utils.Objects;


   /**
    * Implements a few properties and methods common in both flavours of
    * <code>IMTimeEvent</code>. This class is abstract so don't use it directly.
    */
   public class MTimeEvent extends EventDispatcher implements IMTimeEvent
   {
      public function MTimeEvent() {
         super();
      }
      
      
      /* ################### */
      /* ### IMTimeEvent ### */
      /* ################### */

      change_flag var hasOccurred: Boolean = true;
      public function get hasOccurred() : Boolean {
         Objects.throwAbstractPropertyError();
         return false;  // unreachable
      }

      change_flag var occursIn: Boolean = true;
      public function get occursIn() : Number {
         Objects.throwAbstractPropertyError();
         return 0;   // unreachable
      }
      
      [Bindable(event="occursInChange")]
      public function occursInString(timeParts: int = 2): String {
         return DateUtil.secondsToHumanString(occursIn, timeParts);
      }
      
      change_flag var occursAt:Boolean = true;
      public function get occursAt() : Date {
         Objects.throwAbstractPropertyError();
         return null;   // unreachable
      }

      [Bindable(event="occursAtChange")]
      public function occursAtString(includeSeconds: Boolean = false): String {
         return DateUtil.formatShortDateTime(occursAt, includeSeconds);
      }

      public function before(event: IMTimeEvent, epsilon: Number = 0): Boolean {
         Objects.paramNotNull("event", event);
         Objects.paramPositiveNumber("epsilon", epsilon);
         return sameTime(event, epsilon)
                   ? false : this.occursAt.time < event.occursAt.time;
      }

      public function after(event: IMTimeEvent, epsilon: Number = 0): Boolean {
         Objects.paramNotNull("event", event);
         Objects.paramPositiveNumber("epsilon", epsilon);
         return sameTime(event, epsilon)
                   ? false : this.occursAt.time > event.occursAt.time;
      }

      public function sameTime(event: IMTimeEvent, epsilon: Number = 0): Boolean {
         return Math.abs(this.occursAt.time - event.occursAt.time) <= epsilon;
      }


      /* ######################### */
      /* ### IEqualsComparable ### */
      /* ######################### */

      public function equals(o:Object):Boolean {
         if (!(o is MTimeEvent) || Objects.getClassName(this) != Objects.getClassName(o)) {
            return false;
         }
         return NumberUtil.equal(this.occursAt.time, MTimeEvent(o).occursAt.time, 10);
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */

      public function update() : void {
         Objects.throwAbstractMethodError();
      }

      public function resetChangeFlags() : void {
         change_flag::hasOccurred = false;
         change_flag::occursAt = false;
         change_flag::occursIn = false;
      }
      
      
      /* ############## */
      /* ### Object ### */
      /* ############## */
      
      public override function toString() : String {
         return "[class: " + Objects.getClassName(this) +
                ", occursIn: " + occursIn +
                ", occursAt: " + occursAt + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      protected function dispatchSimpleEvent(CLASS:Class, type:String) : void {
         Events.dispatchSimpleEvent(this, CLASS, type);
      }
      
      protected function occursInUpdated() : void {
         change_flag::occursIn = true;
         dispatchSimpleEvent(MTimeEventEvent, MTimeEventEvent.OCCURS_IN_CHANGE);
      }
      
      protected function occursAtUpdated() : void {
         change_flag::occursAt = true;
         dispatchSimpleEvent(MTimeEventEvent, MTimeEventEvent.OCCURS_AT_CHANGE);
      }
      
      protected function hasOccurredUpdated() : void {
         change_flag::hasOccurred = true;
         dispatchSimpleEvent(MTimeEventEvent, MTimeEventEvent.HAS_OCCURRED_CHANGE);
      }
   }
}
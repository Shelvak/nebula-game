package models.time
{
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   
   import models.time.events.MTimeEventEvent;
   
   import namespaces.change_flag;
   
   import utils.EventUtils;
   import utils.NumberUtil;
   import utils.Objects;
   
   
   /**
    * Implements a few properties and methods common in both flavours of <code>IMTimeEvent</code>.
    * This class is abstract so don't use it directly.
    */
   public class MTimeEvent extends EventDispatcher implements IMTimeEvent
   {
      public function MTimeEvent()
      {
         super();
      }
      
      
      /* ################### */
      /* ### IMTimeEvent ### */
      /* ################### */
      
      
      change_flag var hasOccured:Boolean = true;
      public function get hasOccured() : Boolean
      {
         throw new IllegalOperationError("Property is abstract");
      }
      
      
      change_flag var occuresIn:Boolean = true;
      public function get occuresIn() : Number
      {
         throw new IllegalOperationError("Property is abstract");
      }
      
      
      change_flag var occuresAt:Boolean = true;
      public function get occuresAt() : Date
      {
         throw new IllegalOperationError("Property is abstract");
      }
      
      
      /* ######################### */
      /* ### IEqualsComparable ### */
      /* ######################### */
      
      
      public function equals(o:Object):Boolean
      {
         if (!(o is MTimeEvent) ||
             Objects.getClassName(this) != Objects.getClassName(o))
         {
            return false;
         }
         return NumberUtil.equal(this.occuresAt.time, MTimeEvent(o).occuresAt.time, 10);
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */
      
      
      public function update() : void
      {
         throw new IllegalOperationError("Method is abstract");
      }
      
      
      public function resetChangeFlags() : void
      {
         change_flag::hasOccured = false;
         change_flag::occuresAt = false;
         change_flag::occuresIn = false;
      }
      
      
      /* ############## */
      /* ### Object ### */
      /* ############## */
      
      
      public override function toString() : String
      {
         return "[class: " + Objects.getClassName(this) +
                ", occuresIn: " + occuresIn +
                ", occuresAt: " + occuresAt + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * @see utils.EventUtils#dispatchSimpleEvent()
       */
      protected function dispatchSimpleEvent(CLASS:Class, type:String) : void
      {
         EventUtils.dispatchSimpleEvent(this, CLASS, type);
      }
      
      
      protected function occuresInUpdated() : void
      {
         dispatchSimpleEvent(MTimeEventEvent, MTimeEventEvent.OCCURES_IN_CHANGE);
      }
      
      
      protected function occuresAtUpdated() : void
      {
         dispatchSimpleEvent(MTimeEventEvent, MTimeEventEvent.OCCURES_AT_CHANGE);
      }
      
      
      protected function hasOccuredUpdated() : void
      {
         dispatchSimpleEvent(MTimeEventEvent, MTimeEventEvent.HAS_OCCURED_CHANGE);
      }
   }
}
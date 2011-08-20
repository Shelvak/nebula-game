package models.time
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   import utils.DateUtil;
   import utils.Objects;
   

   /**
    * Marks a fixed moment in time.
    * 
    * <p>You set <code>occuresAt</code> to some <code>Date</code> (<code>null</code> is not allowed) and this
    * values remains the same until you set it again. Meanwhile <code>occuresIn</code> is updated when time
    * advances.
    */
   public class MTimeEventFixedMoment extends MTimeEvent
   {
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
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */
      
      
      private var _hasOccuredDispatched:Boolean = false;
      
      
      public override function update() : void
      {
         occuresInUpdated();
         if (!_hasOccuredDispatched && _occuresAt.time <= DateUtil.now)
         {
            _hasOccuredDispatched = true;
            hasOccuredUpdated();
         }
      }
   }
}
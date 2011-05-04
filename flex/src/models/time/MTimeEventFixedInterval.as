package models.time
{
   import utils.DateUtil;
   
   
   /**
    * This marks an event after a fixed time interval in the future.
    * 
    * <p>You set <code>occuresIn</code> to some positive integer (negative is converted to 0) and this values
    * remains the same until you set it again. Meanwhile <code>occuresAt</code> is updated when time advances. 
    */
   public class MTimeEventFixedInterval extends MTimeEvent
   {
      public function MTimeEventFixedInterval()
      {
         super();
      }
      
      
      /* ################### */
      /* ### IMTimeEvent ### */
      /* ################### */
      
      
      private var _occuresIn:Number = 0;
      [Bindable(event="occuresInChange")]
      /**
       * A fixed time interval between now and some future time. This property does not change over time but
       * <code>occuresAt</code> does. If you try to set this property to negative value it will be set to 0
       * instead.
       * 
       * @see IMTimeEvent#occuresIn
       */
      public function set occuresIn(value:Number) : void
      {
         value = Math.floor(value);
         if (_occuresIn != value)
         {
            _occuresIn = value < 0 ? 0 : value;
            occuresAtUpdated();
            occuresInUpdated();
            hasOccuredUpdated();
         }
      }
      /**
       * @private
       */
      public override function get occuresIn() : Number
      {
         return _occuresIn;
      };
      
      
      [Bindable(event="occuresAtChange")]
      public override function get occuresAt() : Date
      {
         return new Date(DateUtil.now + _occuresIn * 1000);
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Allways <code>false</code>.
       * 
       * <p>Metadata:</br>
       * [Bindable(event="willNotChange")]
       * </p>
       */
      public override function get hasOccured() : Boolean
      {
         return false;
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */
      
      
      public override function update() : void
      {
         occuresAtUpdated();
      }
   }
}
package models.time
{
   import utils.DateUtil;


   /**
    * This marks an event after a fixed time interval in the future.
    *
    * <p>You set <code>occursIn</code> to some positive integer (negative is
    * converted to 0) and this values remains the same until you set it again.
    * Meanwhile <code>occursAt</code> is updated when time advances.
    */
   public class MTimeEventFixedInterval extends MTimeEvent
   {
      public function MTimeEventFixedInterval(occursIn: Number = 0) {
         super();
         this.occursIn = occursIn;
      }
      
      /* ################### */
      /* ### IMTimeEvent ### */
      /* ################### */


      private var _occursIn: Number = 0;
      [Bindable(event="occursInChange")]
      /**
       * A fixed time interval between now and some future time. This property
       * does not change over time but <code>occursAt</code> does. If you try
       * to set this property to negative value it will be set to 0 instead.
       *
       * @see IMTimeEvent#occursIn
       */
      public function set occursIn(value: Number): void {
         value = Math.floor(value);
         if (_occursIn != value) {
            _occursIn = value < 0 ? 0 : value;
            occursAtUpdated();
            occursInUpdated();
            hasOccurredUpdated();
         }
      }
      public override function get occursIn(): Number {
         return _occursIn;
      }

      [Bindable(event="occursAtChange")]
      public override function get occursAt(): Date {
         return new Date(DateUtil.now + _occursIn * 1000);
      }

      /**
       * Always <code>false</code>.
       */
      public override function get hasOccurred(): Boolean {
         return false;
      }


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public override function update(): void {
         occursAtUpdated();
      }


      /* ############################ */
      /* ### MTimeEvent OVERRIDES ### */
      /* ############################ */

      public override function equals(o: Object): Boolean {
         if (!(o is MTimeEventFixedInterval)) {
            return false;
         }
         return _occursIn == MTimeEventFixedInterval(o)._occursIn;
      }
   }
}
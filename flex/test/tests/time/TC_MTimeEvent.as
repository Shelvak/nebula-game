package tests.time
{
   import models.time.MTimeEvent;
   import models.time.MTimeEventFixedInterval;
   import models.time.MTimeEventFixedMoment;
   
   import namespaces.change_flag;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   
   public class TC_MTimeEvent
   {
      [Test]
      public function equals_test() : void
      {
         var event0:MTimeEvent;
         var event1:MTimeEvent;
         
         event0 = new MTimeEvent();
         assertThat(
            "should not be equal to null",
            event0.equals(null), isFalse()
         );
         assertThat(
            "should not be equal to a totally different object",
            event0.equals(new Object()), isFalse()
         );
         
         event0 = new MTimeEventFixedInterval(); MTimeEventFixedInterval(event0).occuresIn = 10;
         event1 = new MTimeEventFixedInterval(); MTimeEventFixedInterval(event1).occuresIn = 10;
         assertThat(
            "instances of same subtype with same values should be equal",
            event0.equals(event1), isTrue()
         );
         
         event0 = new MTimeEventFixedInterval(); MTimeEventFixedInterval(event0).occuresIn = 10;
         event1 = new MTimeEventFixedInterval(); MTimeEventFixedInterval(event1).occuresIn = 20;
         assertThat(
            "instances of same subtype with different values should not be equal",
            event0.equals(event1), isFalse()
         );
         
         event0 = new MTimeEventFixedInterval();
         event1 = new MTimeEventFixedMoment();
         assertThat(
            "instances of different subtypes should not be equal",
            event0.equals(event1), isFalse()
         );
      };
      
      
      [Test]
      public function should_set_flags_in_change_flag_namespace_to_false() : void
      {
         var event:MTimeEvent = new MTimeEvent();
         event.change_flag::hasOccured = true;
         event.change_flag::occuresAt = true;
         event.change_flag::occuresIn = true;
         event.resetChangeFlags();
         assertThat( "should reset hasOccured flag", event.change_flag::hasOccured, isFalse() );
         assertThat( "should reset occuresAt flag", event.change_flag::occuresAt, isFalse() );
         assertThat( "should reset occuresIn flag", event.change_flag::occuresIn, isFalse() );
      };
   }
}
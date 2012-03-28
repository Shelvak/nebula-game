package tests.time
{
   import models.time.IMTimeEvent;
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
      public function equals(): void {
         var event0: MTimeEvent;
         var event1: MTimeEvent;

         event0 = new MTimeEvent();
         assertThat(
            "should not be equal to null",
            event0.equals(null), isFalse()
         );
         assertThat(
            "should not be equal to a totally different object",
            event0.equals(new Object()), isFalse()
         );

         event0 = new MTimeEventFixedInterval();
         MTimeEventFixedInterval(event0).occuresIn = 10;
         event1 = new MTimeEventFixedInterval();
         MTimeEventFixedInterval(event1).occuresIn = 10;
         assertThat(
            "instances of same subtype with same values should be equal",
            event0.equals(event1), isTrue()
         );

         event0 = new MTimeEventFixedInterval();
         MTimeEventFixedInterval(event0).occuresIn = 10;
         event1 = new MTimeEventFixedInterval();
         MTimeEventFixedInterval(event1).occuresIn = 20;
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
      }


      [Test]
      public function shouldSetFlagsInChangeFlagNamespaceToFalse(): void {
         var event: MTimeEvent = new MTimeEvent();
         event.change_flag::hasOccured = true;
         event.change_flag::occuresAt = true;
         event.change_flag::occuresIn = true;
         event.resetChangeFlags();
         assertThat(
            "should reset hasOccurred flag",
            event.change_flag::hasOccured, isFalse()
         );
         assertThat(
            "should reset occursAt flag",
            event.change_flag::occuresAt, isFalse()
         );
         assertThat(
            "should reset occursIn flag",
            event.change_flag::occuresIn, isFalse()
         );
      }

      [Test]
      public function before(): void {
         const event0: MTimeEventFixedInterval = new MTimeEventFixedInterval();
         const event1: MTimeEventFixedInterval = new MTimeEventFixedInterval();

         event0.occuresIn = 10;
         event1.occuresIn = 11;
         assertThat(
            "10 seconds should be before 11",
            event0.before(event1, 0), isTrue()
         );
         assertThat(
            "11 seconds should not be before 10",
            event1.before(event0, 0), isFalse()
         );
      }

      [Test]
      public function before_withEpsilon(): void {
         const event0: MTimeEventFixedMoment = new MTimeEventFixedMoment();
         const event1: MTimeEventFixedMoment = new MTimeEventFixedMoment();

         event0.occuresAt = new Date(2000, 0, 1, 0, 0, 0,  0);
         event1.occuresAt = new Date(2000, 0, 1, 0, 0, 0, 20);
         assertThat(
            "0 milliseconds should be before 20 when epsilon is 10",
            event0.before(event1, 10), isTrue()
         );
         assertThat(
            "20 milliseconds should not be before 0 when epsilon is 10",
            event1.before(event0, 10), isFalse()
         );
         assertThat(
            "0 milliseconds should not be before 20 when epsilon is 50",
            event0.before(event1, 50), isFalse()
         );
         assertThat(
            "20 milliseconds should not be before 0 when epsilon is 50",
            event0.before(event1, 50), isFalse()
         );
      }

      [Test]
      public function after(): void {
         const event0: MTimeEventFixedInterval = new MTimeEventFixedInterval();
         const event1: MTimeEventFixedInterval = new MTimeEventFixedInterval();

         event0.occuresIn = 10;
         event1.occuresIn = 11;
         assertThat(
            "11 seconds should be after 10",
            event1.after(event0, 0), isTrue()
         );
         assertThat(
            "10 seconds should not be after 11",
            event0.after(event1, 0), isFalse()
         );
      }

      [Test]
      public function after_withEpsilon(): void {
         const event0: MTimeEventFixedMoment = new MTimeEventFixedMoment();
         const event1: MTimeEventFixedMoment = new MTimeEventFixedMoment();

         event0.occuresAt = new Date(2000, 0, 1, 0, 0, 0, 0);
         event1.occuresAt = new Date(2000, 0, 1, 0, 0, 0, 20);
         assertThat(
            "20 milliseconds should be after 0 when epsilon is 10",
            event1.after(event0, 10), isTrue()
         );
         assertThat(
            "0 milliseconds should not be after 20 when epsilon is 10",
            event0.after(event1, 10), isFalse()
         );
         assertThat(
            "0 milliseconds should not be after 20 when epsilon is 50",
            event0.after(event1, 50), isFalse()
         );
         assertThat(
            "20 milliseconds should not be after 0 when epsilon is 50",
            event0.after(event1, 50), isFalse()
         );
      }

      [Test]
      public function sameTime(): void {
         const event0: MTimeEventFixedMoment = new MTimeEventFixedMoment();
         const event1: MTimeEventFixedMoment = new MTimeEventFixedMoment();

         event0.occuresAt = new Date(2000, 0, 1, 0, 0, 0, 0);
         event1.occuresAt = new Date(2000, 0, 1, 0, 0, 0, 0);
         assertThat(
            "should define the same time when epsilon is 0",
            event0.sameTime(event1), isTrue()
         );

         event1.occuresAt.time += 10;
         assertThat(
            "should not define same time when epsilon is 0",
            event0.sameTime(event1), isFalse()
         );

         assertThat(
            "should not define same time when epsilon greater than time delta",
            event0.sameTime(event1, 5), isFalse()
         );
         assertThat(
            "should define same time when epsilon is less than or equal to time delta",
            event0.sameTime(event1, 10), isTrue()
         );
      }
   }
}
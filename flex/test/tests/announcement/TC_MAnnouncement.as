package tests.announcement
{
   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causesTarget;
   import ext.hamcrest.object.equals;
   
   import interfaces.IUpdatable;
   
   import models.announcement.MAnnouncement;
   import models.announcement.MAnnouncementEvent;
   
   import namespaces.change_flag;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.isA;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   
   import utils.DateUtil;

   public class TC_MAnnouncement
   {
      private var announcement:MAnnouncement;

      [BeforeClass]
      public static function setUpClass(): void {
         DateUtil.timeDiff = 0;
      }

      [Before]
      public function setUp() : void {
         DateUtil.now = new Date().time;
         announcement = new MAnnouncement();
      }

      [After]
      public function tearDown() : void {
         announcement = null;
      }

      [Test]
      public function messageAndMessageTextFlowAndEventProps() : void {
         assertThat( "default value of message prop", announcement.message, nullValue() );
         assertThat( "default value of event prop", announcement.event, notNullValue() );
         
         assertThat( "setting message to null", function():void{ announcement.message = null }, not (throws (TypeError)) );
         assertThat( "when message is null, messageTextFlow is also null", announcement.messageTextFlow, nullValue() );
         
         announcement.message = "Server shutdown!";
         assertThat( "change message prop", announcement.message, equals ("Server shutdown!") );
         assertThat( "create messageTextFlow", announcement.messageTextFlow, notNullValue() );
         assertThat(
            "messageTextFlow holds same text as message",
            announcement.messageTextFlow.getText(), equals (announcement.message)
         );
         
         assertThat(
            "malformed HTML causes exception",
            function():void{ announcement.message = "<a>Message" }, throws (TypeError)
         );
         
         assertThat(
            "changing message prop", function():void{ announcement.message = "Message" },
            causesTarget(announcement) .toDispatchEvent (MAnnouncementEvent.MESSAGE_CHANGE)
         );
      }
      
      [Test]
      public function update() : void {
         assertThat( "announcement is updatable", announcement, isA (IUpdatable) );
         announcement.update();
         assertThat( "event is updated", announcement.event.change_flag::occuresAt, isTrue() );
         announcement.resetChangeFlags();
         assertThat( "event is reset", announcement.event.change_flag::occuresAt, isFalse() );
      }
      
      [Test]
      public function buttonVisible() : void {
         announcement.event.occuresAt = new Date(2000, 0, 1);
         assertThat( "not visible if past event", announcement.buttonVisible, isFalse() );
         
         announcement.event.occuresAt = new Date(2100, 0, 1);
         assertThat( "visible if future event", announcement.buttonVisible, isTrue() );

         assertThat(
            "advancing time",
            function():void{
               DateUtil.now = new Date(2200, 0, 2).time;
               announcement.update();
            },
            causesTarget(announcement) .toDispatchEvent (MAnnouncementEvent.BUTTON_VISIBLE_CHANGE)
         );
      }
      
      [Test]
      public function reset() : void {
         announcement.event.occuresAt = new Date(2200, 0, 1);
         announcement.message = "Message";
         announcement.reset();
         assertThat( "message cleared", announcement.message, nullValue() );
         assertThat( "event reset", announcement.event.occuresAt, dateEqual (new Date(0)) );
         
         assertThat(
            "resetting announcement model", function():void{ announcement.reset() },
            causesTarget(announcement) .toDispatchEvent (MAnnouncementEvent.RESET)
         );
      }
   }
}
package tests.chat.models
{
   import ext.hamcrest.events.causesTarget;
   
   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;
   
   import org.hamcrest.assertThat;
   
   
   public class TC_MChatMember
   {
      public function TC_MChatMember()
      {
      }
      
      
      private var member:MChatMember;
      
      
      [Before]
      public function setUp() : void
      {
         member = new MChatMember(1, "mikism");
      };
      
      
      [After]
      public function tearDown() : void
      {
         member = null;
      };
      
      
      [Test]
      public function should_dispatch_IS_ONLINE_CHANGE_event_when_isOnline_property_changes() : void
      {
         assertThat(
            function():void{ member.isOnline = true },
            causesTarget (member) .toDispatchEvent (MChatMemberEvent.IS_ONLINE_CHANGE)
         );
         assertThat(
            function():void{ member.isOnline = false },
            causesTarget (member) .toDispatchEvent (MChatMemberEvent.IS_ONLINE_CHANGE)
         );
      };
   }
}
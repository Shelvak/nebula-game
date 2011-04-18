package tests.chat.models
{
   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isTrue;
   
   
   public class TCMChatMember
   {
      public function TCMChatMember()
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
         var eventDispatched:Boolean;
         member.addEventListener(
            MChatMemberEvent.IS_ONLINE_CHANGE,
            function(event:MChatMemberEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         eventDispatched = false;
         member.isOnline = true;
         assertThat( eventDispatched, isTrue() );
         
         eventDispatched = false;
         member.isOnline = false;
         assertThat( eventDispatched, isTrue() );
      };
   }
}
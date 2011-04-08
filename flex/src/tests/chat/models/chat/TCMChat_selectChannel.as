package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;
   
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isTrue;

   public class TCMChat_selectChannel extends TCBaseMChat
   {
      public function TCMChat_selectChannel()
      {
         super();
      };
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         chat.initialize({}, {"galaxy": [], "alliance": [], "noobs": []});
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
      };
      
      
      [Test]
      public function should_select_given_channel() : void
      {
         chat.selectChannel("noobs");
         assertThat( chat.selectedChannel, chat.channels.getChannel("noobs") );
      };
      
      
      [Test]
      public function should_do_nothing_when_trying_to_select_already_selected_channel() : void
      {
         chat.selectChannel("noobs");
         chat.selectChannel("noobs");
         assertThat( chat.selectedChannel, chat.channels.getChannel("noobs") );
      };
      
      
      [Test]
      public function should_dispatch_SLECTED_CHANNEL_CHANGE_event_when_selected_another_channel() : void
      {
         var eventDispatched:Boolean = false;
         chat.addEventListener(
            MChatEvent.SELECTED_CHANNEL_CHANGE,
            function(event:MChatEvent) : void
            {
               eventDispatched = true;
            }
         );
         chat.selectChannel("noobs");
         assertThat( eventDispatched, isTrue() );
      };
   }
}
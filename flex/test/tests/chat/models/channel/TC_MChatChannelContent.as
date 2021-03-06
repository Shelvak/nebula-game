package tests.chat.models.channel
{
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;
   
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.ParagraphElement;
   
   import models.chat.ChatConstants;
   import models.chat.MChatChannelContent;
   import models.chat.events.MChatChannelContentEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.notNullValue;
   
   
   public class TC_MChatChannelContent
   {
      private var content:MChatChannelContent;
      
      [Before]
      public function setUp() : void {
         content = new MChatChannelContent();
      };
      
      [After]
      public function tearDown() : void {
         content = null;
      };
      
      
      [Test]
      public function should_instantiate_empty_TextFlow_instance() : void {
         content = new MChatChannelContent();
         assertThat( content.text, notNullValue() );
         assertThat( content.text.numChildren, equals (0) );
      };
      
      [Test]
      public function should_add_new_message_to_the_end_of_TextFlow_instance() : void {
         var p0:ParagraphElement = new ParagraphElement();
         content.addMessage(p0);
         assertThat( content.text.numChildren, equals (1) );
         assertThat( content.text.getChildAt(0), equals (p0) );
         
         var p1:ParagraphElement = new ParagraphElement();
         content.addMessage(p1);
         assertThat( content.text.numChildren, equals (2) );
         assertThat( content.text.getChildAt(1), equals (p1) );
      };
      
      
      [Test]
      public function should_remove_oldest_element_if_maximum_reached() : void {
         for (var i:int = 0; i < ChatConstants.MAX_MESSAGES_IN_CHANNEL; i++) {
            content.addMessage(new ParagraphElement());
         }
         assertThat( content.text.numChildren, equals (ChatConstants.MAX_MESSAGES_IN_CHANNEL) ); 
         
         var toBeRemoved:ParagraphElement = ParagraphElement(content.text.getChildAt(0));
         var newParagraph:ParagraphElement = new ParagraphElement();
         
         content.addMessage(newParagraph);
         assertThat( content.text.numChildren, equals (ChatConstants.MAX_MESSAGES_IN_CHANNEL) );
         assertThat( content.text.getChildIndex(toBeRemoved), equals (-1) );
         assertThat( content.text.getChildAt(ChatConstants.MAX_MESSAGES_IN_CHANNEL - 1), equals (newParagraph) );
      }
      
      [Test]
      public function messageAddAndMessageRemoveEvents() : void {
         assertThat(
            "adding new message", function():void{ content.addMessage(new ParagraphElement()) },
            causes(content) .toDispatchEvent (MChatChannelContentEvent.MESSAGE_ADD)
         );
         
         for (var i:int = 0; i < ChatConstants.MAX_MESSAGES_IN_CHANNEL; i++) {
            content.addMessage(new ParagraphElement());
         }
         assertThat(
            "removing oldest message", function():void{ content.addMessage(new ParagraphElement()) },
            causes(content) .toDispatchEvent (MChatChannelContentEvent.MESSAGE_REMOVE)
         );
      }
   }
}
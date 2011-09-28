package tests.chat.models
{
   import controllers.startup.StartupInfo;
   
   import ext.hamcrest.object.equals;
   
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.MChatMessage;
   import models.chat.msgconverters.IChatMessageConverter;
   import models.chat.msgconverters.MemberMessageConverter;
   
   import mx.resources.IResourceBundle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.isA;
   
   import utils.locale.Locale;

   public class TC_MessageConverters
   {
      private function get RM() : IResourceManager {
         return ResourceManager.getInstance();
      }
      
      
      private var converter:IChatMessageConverter;
      private var message:MChatMessage;
      private var paragraph:ParagraphElement;
      private var link:LinkElement;
      private var span:SpanElement;
      
      
      [Before]
      public function setUp() : void {
         StartupInfo.getInstance().locale = Locale.EN;
         var rb:IResourceBundle = new ResourceBundle(Locale.currentLocale, "Chat");
         rb.content["format.time"] = "YYYY-MM-DD";
         RM.addResourceBundle(rb);
         
         message = new MChatMessage();
         message.playerName = "player";
         message.time = new Date(2000, 0, 1);
         converter = new MemberMessageConverter();
      }
      
      [After]
      public function tearDown() : void {
         message = null;
         converter = null;
         paragraph = null;
         link = null;
         RM.removeResourceBundlesForLocale(Locale.currentLocale);
      }
      
      
      [Test]
      public function messageParsing_onlySimpleText() : void {
         message.message = "Simple message";
         convertToParagraph();
         
         assertParagraphNumChildren(3);
         spanAssersions(2);
      }
      
      [Test]
      public function messageParsing_onlyURL() : void {
         message.message = "http://nebula44.com/";
         convertToParagraph();
         assertParagraphNumChildren(3);
         linkAssertions(2);
         
         message.message = "www.nebula44.lt";
         convertToParagraph();
         assertParagraphNumChildren(3);
         linkAssertions(2, "http://www.nebula44.lt");
         
         message.message = "http://www.nebula44.com";
         convertToParagraph();
         assertParagraphNumChildren(3);
         linkAssertions(2, "http://www.nebula44.com");
         
         message.message = "www.nebula44.com/list?user=mikism";
         convertToParagraph();
         assertParagraphNumChildren(3);
         linkAssertions(2, "http://www.nebula44.com/list?user=mikism");
      }
      
      [Test]
      public function messageParsing_simpleTextBeforeURL() : void {
         message.message = "My website: http://nebula44.com/list?user=mikism";
         convertToParagraph();
      
         assertParagraphNumChildren(4);
         spanAssersions(2, "My website: ");
         linkAssertions(3, "http://nebula44.com/list?user=mikism");
      }
      
      [Test]
      public function messageParsing_URLEncodedUrls() : void {
         message.message = "My website: http://static.nebula44.lt/?server=" +
            "game.nebula44.lt&web_host=nebula44.lt%3A80&assets_url=" +
            "http%3A%2F%2Fstatic.nebula44.lt%2F&combat_log_id=" +
            "3e84b7f016b4cc19e7ad2d3da1e885cce956c98e&player_id=684&locale=lt";
         convertToParagraph();
         
         assertParagraphNumChildren(4);
         spanAssersions(2, "My website: ");
         linkAssertions(3, "http://static.nebula44.lt/?server=" +
            "game.nebula44.lt&web_host=nebula44.lt:80&assets_url=" +
            "http://static.nebula44.lt/&combat_log_id=" +
            "3e84b7f016b4cc19e7ad2d3da1e885cce956c98e&player_id=684&locale=lt");
      }
      
      [Test]
      public function messageParsing_simpleTextAfterURL() : void {
         message.message = "http://nebula44.com/list?user=mikism is my website";
         convertToParagraph();
         
         assertParagraphNumChildren(4);
         linkAssertions(2, "http://nebula44.com/list?user=mikism");
         spanAssersions(3, " is my website");
      }
      
      [Test]
      public function messageParsing_simpleTextBlocksAndURLsMix() : void {
         message.message = "Hi! Check this out: http://nebula44.com/. And these also: http://one.com http://two.com";
         convertToParagraph();
         
         assertParagraphNumChildren(8);
         spanAssersions(2, "Hi! Check this out: ");
         linkAssertions(3, "http://nebula44.com/.");
         spanAssersions(4, " And these also: ");
         linkAssertions(5, "http://one.com");
         spanAssersions(6, " ");
         linkAssertions(7, "http://two.com");
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function assertParagraphChildType(childIdx:int, CLASS:Class) : void {
         assertThat( "element " + childIdx + " type", paragraph.getChildAt(childIdx), isA (CLASS) );
      }
      
      private function assertParagraphNumChildren(numChildren:int) : void {
         assertThat( "number of elements in paragraph", paragraph.numChildren, equals (numChildren) );
      }
      
      private function spanAssersions(idx:int, text:String = null) : void {
         assertParagraphChildType(idx, SpanElement);
         if (text == null)
            text = message.message;
         // TODO: use SpaneElement.getText() instead of SpaneElement.text when we migrate to 4.5.1
         assertThat( "spanElement.getText()", getSpan(idx).text, equals (text) );
      }
      
      private function linkAssertions(idx:int, url:String = null) : void {
         assertParagraphChildType(idx, LinkElement);
         if (url == null)
            url = message.message;
         var link:LinkElement = getLink(idx);
         assertThat( "linkElement.getText()", link.getText(), equals (url) );
         assertThat( "linkElement.href", link.href, equals (url) );
         assertThat( "linkElement.target", link.target, equals ("_blank") );
      }
      
      private function getLink(idx:int) : LinkElement {
         return LinkElement(paragraph.getChildAt(idx));
      }
      
      private function getSpan(idx:int) : SpanElement {
         return SpanElement(paragraph.getChildAt(idx));
      }
      
      private function convertToParagraph() : void {
         paragraph = ParagraphElement(converter.toFlowElement(message));
      }
   }
}
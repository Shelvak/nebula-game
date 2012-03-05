package tests.chat.classes
{
   import mx.resources.IResourceBundle;
   
   import utils.locale.Locale;
   
   
   public class ChatResourceBundle implements IResourceBundle
   {
      public function ChatResourceBundle()
      {
      }
      
      
      public function get bundleName() : String
      {
         return "Chat";
      }
      
      
      private var _content:Object = {
         "format.time": "HH:NN:SS",
         "message.channelJoin": "{0} joined",
         "message.channelLeave": "{1} left",
         "message.memberIgnored": "ignored",
         "label.privateChannel": "Private channel: {0}",
         "label.mainChannel": "Galaxy",
         "label.allianceChannel": "Alliance",
         "label.channelMembers": "Players"
      };
      public function get content() : Object
      {
         return _content;
      }
      
      
      public function get locale() : String
      {
         return Locale.EN;
      }
   }
}
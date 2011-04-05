package tests.chat.classes
{
   import mx.resources.IResourceBundle;
   
   
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
         "label.privateChannel": "Private channel: {0}"
      };
      public function get content() : Object
      {
         return _content;
      }
      
      
      public function get locale() : String
      {
         return "en_US";
      }
   }
}
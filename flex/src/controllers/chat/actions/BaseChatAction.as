package controllers.chat.actions
{
   import controllers.CommunicationAction;
   
   import models.chat.MChat;
   
   
   public class BaseChatAction extends CommunicationAction
   {
      /**
       * Reference to <code>MChat</code> singleton.
       */
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      public function BaseChatAction()
      {
         super();
      }
   }
}
package controllers.chat.actions
{
   import controllers.CommunicationAction;
   
   import models.chat.MChat;
   
   import utils.pool.IObjectPool;
   
   
   public class BaseChatAction extends CommunicationAction
   {
      /**
       * Reference to <code>MChat</code> singleton.
       */
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      /**
       * Reference to <code>MChatMessage</code> pool in <code>MCHAT</code>.
       */
      protected function get messagePool() : IObjectPool
      {
         return MCHAT.messagePool;
      }
      
      
      public function BaseChatAction()
      {
         super();
      }
   }
}
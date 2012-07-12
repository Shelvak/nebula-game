package controllers.chat.actions
{
   import controllers.CommunicationAction;

   import models.chat.MChat;

   import utils.pool.IObjectPool;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   public class BaseChatAction extends CommunicationAction
   {
      /**
       * Reference to <code>MChat</code> singleton.
       */
      protected function get MCHAT(): MChat {
         return MChat.getInstance();
      }

      /**
       * Reference to <code>MChatMessage</code> pool in <code>MCHAT</code>.
       */
      protected function get messagePool(): IObjectPool {
         return MCHAT.messagePool;
      }


      override public function result(rmo: ClientRMO): void {
      }

      override public function cancel(rmo: ClientRMO, srmo: ServerRMO): void {
      }
   }
}
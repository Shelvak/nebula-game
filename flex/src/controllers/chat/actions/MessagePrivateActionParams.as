package controllers.chat.actions
{
   import models.chat.MChatMessage;
   
   
   /**
    * Aggregates parameters of <code>controllers.chat.actions.MessagePrivateAction</code> client command.
    * 
    * @see #MessagePublicActionParams()
    * @see #message
    */
   public class MessagePrivateActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #message
       */
      public function MessagePrivateActionParams(message:MChatMessage)
      {
         this.message = message;
      }
      
      
      /**
       * A message to be sent. Only <code>playerId</code> and <code>message</code> (upto 255 symbols)
       * properties will be used and therefore should be set. The instance will not be
       * returned to <code>MChat.messagePool</code> by the action. <b>Required. Not null.</b>
       */
      public var message:MChatMessage;
   }
}
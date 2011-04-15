package controllers.chat.actions
{
   import models.chat.MChatMessage;

   /**
    * Aggregates parameters of <code>controllers.chat.actions.MessagePublicAction</code> client command.
    * 
    * @see #MessagePublicActionParams()
    * @see #message
    */
   public class MessagePublicActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #message
       */
      public function MessagePublicActionParams(message:MChatMessage)
      {
         this.message = message;
      }
      
      
      /**
       * A message to be sent. Only <code>playerId</code>, <code>channel</code> and <code>message</code> (up
       * to 255 symbols) properties will be used and therefore should be set. The instance will not be
       * returned to <code>MChat.messagePool</code> by the action. <b>Required. Not null.</b>
       */
      public var message:MChatMessage;
   }
}
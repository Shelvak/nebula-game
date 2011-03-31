package controllers.chat
{
   import controllers.CommunicationCommand;
   
   import utils.remote.rmo.RemoteMessageObject;
   
   
   public class ChatCommand extends CommunicationCommand
   {
      /**
       * @see controllers.chat.actions.IndexAction
       */
      public static const INDEX:String = "chat|index";
      
      
      /**
       * @see controllers.chat.actions.MessagePublicAction
       */
      public static const MESSAGE_PUBLIC:String = "chat|c";
      
      
      /**
       * @see controllers.chat.actions.MesssagePrivateAction
       */
      public static const MESSAGE_PRIVATE:String = "chat|m";
      
      
      /**
       * @see controllers.chat.actions.ChannelJoinAction
       */
      public static const CHANNEL_JOIN:String = "chat|chan_join";
      
      
      /**
       * @see controllers.chat.actions.ChannelLeaveAction
       */
      public static const CHANNEL_LEAVE:String = "chat|chan_leave";
      
      
      public function ChatCommand(type:String,
                                  parameters:Object = null,
                                  fromServer:Boolean = false,
                                  eagerDispatch:Boolean = false,
                                  rmo:RemoteMessageObject = null)
      {
         super(type, parameters, fromServer, eagerDispatch, rmo);
      }
   }
}
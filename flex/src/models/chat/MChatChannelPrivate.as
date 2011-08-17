package models.chat
{
   import components.chat.IRChatMember;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateActionParams;
   
   import flash.errors.IllegalOperationError;
   
   import interfaces.ICleanable;
   
   import models.chat.events.MChatChannelEvent;
   import models.chat.events.MChatMemberEvent;
   
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   
   import utils.locale.Localizer;
   
   
   /**
    * @see models.chat.events.MChatChannelEvent#IS_FRIEND_ONLINE_CHANGE
    */
   [Event(name="isFriendOnlineChange", type="models.chat.events.MChatChannelEvent")]
   
   
   public class MChatChannelPrivate extends MChatChannel implements ICleanable
   {
      public function MChatChannelPrivate(name:String)
      {
         super(name);
      }
      
      
      public function cleanup() : void
      {
         if (_friend != null)
         {
            _friend.removeEventListener(MChatMemberEvent.IS_ONLINE_CHANGE, friend_isOnlineChangeHandler, false);
            _friend = null;
         }
      }
      
      
      /**
       * Combination of text from "Chat" bundle and <code>name</code>.
       */
      public override function get displayName() : String
      {
         return Localizer.string("Chat", "label.privateChannel", [name]);
      }
      
      /**
       * Returns <code>false</code>.
       */
      public override function get isPublic() : Boolean {
         return false;
      }
      
      
      private var _friendIRFactory:ClassFactory = new ClassFactory(IRChatMember);
      /**
       * Returns factory of <code>IRChatMember</code> for friend and factory of
       * <code>DefaultItemRenderer</code> for player.
       */
      public override function membersListIRFactory(member:MChatMember) : IFactory
      {
         if (member.isPlayer)
         {
            return super.membersListIRFactory(member);
         }
         return _friendIRFactory;
      }
      
      
      // set in <code>memberJoin()</code> method.
      private var _friend:MChatMember = null;
      /**
       * Instance of <code>MChatMember</code> that represents player's friend in this channel.
       * Is set to <code>null</code> after cleanup.
       * 
       * <p>No property change event.</p> 
       */
      public function get friend() : MChatMember
      {
         return _friend;
      }
      
      
      /**
       * Indicates if friend of the player in this channel is online. When this property changes
       * <code>MChatChannelEvent.IS_FRIEND_ONLINE_CHANGE</code> event is dispatched.
       * 
       * <p>
       * No property change event.</br>
       * Default is <code>false</code>.
       * </p>
       */
      public function get isFriendOnline() : Boolean
      {
         return _friend != null && _friend.isOnline;
      }
      private function dispatchIsFriendOnlineChangeEvent() : void
      {
         dispatchSimpleEvent(MChatChannelEvent, MChatChannelEvent.IS_FRIEND_ONLINE_CHANGE);
      }
      
      
      private function friend_isOnlineChangeHandler(event:MChatMemberEvent) : void
      {
         dispatchIsFriendOnlineChangeEvent();
      }
      
      
      public override function memberJoin(member:MChatMember, addMessage:Boolean = true) : void
      {
         if (members.length >= 2)
         {
            throw new IllegalOperationError(
               "Unable to join member " + member + " to channel " + this + ": private channel already " +
               "has 2 members: " + members.toArray()
            );
         }
         super.memberJoin(member, addMessage);
         
         if (!member.isPlayer)
         {
            _friend = member;
            _friend.addEventListener(
               MChatMemberEvent.IS_ONLINE_CHANGE, friend_isOnlineChangeHandler, false, 0, true
            );
            dispatchIsFriendOnlineChangeEvent();
         }
      }
      
      
      public override function sendMessage(message:String) : void
      {
         var msg:MChatMessage = MChatMessage(MCHAT.messagePool.borrowObject());
         msg.message = message;
         msg.playerId = _friend.id;
         msg.channel = name;
         
         new ChatCommand(ChatCommand.MESSAGE_PRIVATE, new MessagePrivateActionParams(msg)).dispatch();
      }
      
      
      public override function messageSendSuccess(message:MChatMessage) : void
      {
         message.playerId = ML.player.id;
         message.playerName = ML.player.name;
         message.time = new Date();
         super.messageSendSuccess(message);
      }
   }
}
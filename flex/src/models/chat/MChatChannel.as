package models.chat
{
   import components.chat.IRChatMember;

   import flash.errors.IllegalOperationError;

   import models.BaseModel;
   import models.ModelLocator;
   import models.chat.events.MChatChannelEvent;
   import models.chat.msgconverters.ChannelJoinMessageConverter;
   import models.chat.msgconverters.ChannelLeaveMessageConverter;
   import models.chat.msgconverters.IChatMessageConverter;
   import models.chat.msgconverters.MemberMessageConverter;
   import models.chat.msgconverters.PlayerMessageConverter;
   import models.time.MTimeEventFixedMoment;

   import mx.core.ClassFactory;
   import mx.core.IFactory;

   import utils.Objects;


   [Event(name="hasUnreadMessagesChange", type="models.chat.events.MChatChannelEvent")]
   [Event(name="numMembersChange", type="models.chat.events.MChatChannelEvent")]
   [Event(name="generateJoinLeaveMsgsChange", type="models.chat.events.MChatChannelEvent")]
   [Event(name="userInputChange", type="models.chat.events.MChatChannelEvent")]
   
   /**
    * A channel of the chat.
    * 
    * <p>Holds a list of <code>MChatMember</code>s in this channel as an intance of
    * <code>MChatMembersList</code> as well as all its content as an instance of
    * <code>MChatChannelContent</code>.
    */   
   public class MChatChannel extends BaseModel
   {
      protected function get MCHAT() : MChat {
         return MChat.getInstance();
      }
      
      protected function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      /**
       * @param name name of the channel. Each channel must have a unique name.
       *        <b>Not null. Not empty string.</b>
       */
      public function MChatChannel(name: String) {
         super();
         _name = Objects.paramNotEquals("name", name, [null, ""]);
         _content = new MChatChannelContent();
         _members = new MChatMembersList(this);
      }

      public function get silenced(): MTimeEventFixedMoment {
         return MCHAT.silenced;
      }
      
      private var _name:String = null;
      /**
       * Name of this channel. Don't use this as display name (use <code>displayName</code> isntead).
       * Never null.
       */
      public function get name() : String {
         return _name;
      }
      
      /**
       * Is this a public or private channel?
       */
      public function get isPublic() : Boolean {
         throw new IllegalOperationError("Property is abstract!");
      }

      private var _userInput: String = "";
      public function set userInput(value: String): void {
         if (_userInput != value) {
            _userInput = value;
            dispatchChannelEvent(MChatChannelEvent.USER_INPUT_CHANGE);
         }
      }
      public function get userInput(): String {
         return _userInput;
      }
      
      /* ########## */
      /* ### UI ### */
      /* ########## */
      
      /**
       * Name of this channel that should be displayed for the user. Property is abstract.
       */
      public function get displayName() : String {
         throw new IllegalOperationError("Property is abstract");
      }
      
      private var _visible:Boolean = false;
      /**
       * Is <code>true</code> if player is looking at this channel right now.
       */
      public function set visible(value:Boolean) : void {
         if (_visible != value) {
            _visible = value;
            if (_visible)
               setHasUnreadMessages(false);
         }
      }
      /**
       * @private
       */
      public function get visible() : Boolean {
         return _visible;
      }
      
      private var _hasUnreadMessages:Boolean = false;
      [Bindable(event="hasUnreadMessagesChange")]
      /**
       * Indicates if player has read all the messages in this channel. It is immediately assumed to be true
       * when player selects this channel. When this property changes
       * <code>MChatChannelEvent.HAS_UNREAD_MESSAGES_CHANGE</code> event is dispatched.
       * 
       * <p>Metadata:</br>
       * [Bindable(event="hasUnreadMessagesChange")]
       * </p>
       * 
       * <p>No property change event.</p>
       */
      public function get hasUnreadMessages() : Boolean {
         return _hasUnreadMessages;
      }
      private function setHasUnreadMessages(value:Boolean) : void {
         if (_hasUnreadMessages != value) {
            _hasUnreadMessages = value;
            dispatchChannelEvent(MChatChannelEvent.HAS_UNREAD_MESSAGES_CHANGE);
         }
      }
      
      private var _membersListIRFactory:ClassFactory =
                     new ClassFactory(IRChatMember);
      /**
       * Item renderer function to use by <code>MChatMembersList</code>.
       * <code>MChatChannel.membersListIRFunction</code> returns the same <code>ClassFactory</code> instance
       * for <code>DefaultItemRenderer</code>.
       */
      public function membersListIRFactory(member:MChatMember) : IFactory {
         return _membersListIRFactory;
      }
      
      
      /* ############### */
      /* ### CONTENT ### */
      /* ############### */
      
      private var _content:MChatChannelContent;
      /**
       * Content (messages) of this channel. Never null.
       */
      public function get content() : MChatChannelContent {
         return _content;
      }
      
      
      /* ############################## */
      /* ### MESSAGE RECEIVE / SEND ### */
      /* ############################## */
      
      /**
       * Called by <code>MChatChannel</code> when a message has been received. This method converts
       * given message to <code>FlowElement</code> and adds it to <code>content</code>.
       * 
       * @param message a <code>MChatMessage</code> received to be added to the channel content.
       */
      public function receiveMessage(message: MChatMessage): void {
         if (message.time == null) {
            message.time = new Date();
         }
         message.converter = MemberMessageConverter.getInstance();
         content.addMessage(message.toFlowElement(onPlayerElementClick));
         MCHAT.messagePool.returnObject(message);
         if (!_visible) {
            setHasUnreadMessages(true);
         }
         dispatchChannelEvent(MChatChannelEvent.GOT_SOME_MESSAGE);
      }

      private function onPlayerElementClick(playerId: int,
                                            playerName: String): void {
         userInput = playerName + ": ";
      }
      
      /**
       * Posts given message to this channel. Once response is received from the server,
       * either <code>messageSendSuccess()</code> or <code>messageSendFailure()</code> is invoked.
       * This method is abstract and must be overridden.
       * 
       * @param message message text to post to the channel.
       */
      public function sendMessage(message:String) : void {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      /**
       * Called when a message has successfully been posted to the channel.
       * 
       * @param message <code>MChatMessage</code> which has successfully been posted to the channel.
       */
      public function messageSendSuccess(message:MChatMessage) : void {
         message.converter = PlayerMessageConverter.getInstance();
         message.time = new Date();
         content.addMessage(message.toFlowElement());
         MCHAT.messagePool.returnObject(message);
         dispatchChannelEvent(MChatChannelEvent.GOT_SOME_MESSAGE);
      }
      
      /**
       * Called when a message could not be posted to the channel. In <code>MChatChannel</code>
       * <code>message</code> is returned to the <code>MChat.messagePool</code>.
       * 
       * @param message <code>MChatMessage</code> which was rejected by the server for some reason.
       */
      public function messageSendFailure(message:MChatMessage) : void {
         MCHAT.messagePool.returnObject(message);
      }
      
      
      /* ############### */
      /* ### MEMBERS ### */
      /* ############### */

      private var _members: MChatMembersList;
      /**
       * List of all channel members. Never null.
       * 
       * <p>Do not modify this list directly. Use <code>memberJoin()</code> and
       * <code>memberLeave()</code> methods</p>.
       */
      public function get members() : MChatMembersList {
         return _members;
      }
      
      [Bindable(event="numMembersChange")]
      /**
       * Number of members in the channel.
       */
      public function get numMembers() : int {
         return _members.length;
      }
      
      /**
       * Should the number of members be visible for the user?
       */
      public function get numMembersVisible() : Boolean {
         return isPublic;
      }
      
      private var _generateJoinLeaveMsgs:Boolean = false;
      [Bindable(event="generateJoinLeaveMsgsChange")]
      /**
       * Should member join / leave messages be generated?
       */
      public function set generateJoinLeaveMsgs(value:Boolean) : void {
         if (_generateJoinLeaveMsgs != value) {
            _generateJoinLeaveMsgs = value;
            dispatchChannelEvent(MChatChannelEvent.GENERATE_JOIN_LEAVE_MSGS_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get generateJoinLeaveMsgs() : Boolean {
         return _generateJoinLeaveMsgs;
      }
      
      /**
       * Called when a chat member has joined this channel. Optionally adds a message to channel content.
       * 
       * @param member new member of the channel.
       * @param addMessage if <code>true</code> (default) will add message about the joined member to
       *        the content of this channel.
       * 
       * @see MChatMembersList#addMember()
       */
      public function memberJoin(member:MChatMember, addMessage:Boolean = true) : void {
         _members.addMember(member);
         if (_generateJoinLeaveMsgs && addMessage)
            addMemberExistanceChangeMessage(member, ChannelJoinMessageConverter.getInstance());
         dispatchChannelEvent(MChatChannelEvent.NUM_MEMBERS_CHANGE);
      }
      
      /**
       * Called when a chat member has left this channel. Always adds a message to channel content.
       * 
       * @param member a member who has left this channel.
       * 
       * @see MChatMembersList#removeMember()
       */
      public function memberLeave(member:MChatMember) : void {
         _members.removeMember(member);
         if (_generateJoinLeaveMsgs)
            addMemberExistanceChangeMessage(member, ChannelLeaveMessageConverter.getInstance());
         dispatchChannelEvent(MChatChannelEvent.NUM_MEMBERS_CHANGE);
      }
      
      private function addMemberExistanceChangeMessage(member:MChatMember,
                                                       messageConverter:IChatMessageConverter) : void {
         var msg:MChatMessage = MChatMessage(MCHAT.messagePool.borrowObject());
         msg.playerId = member.id;
         msg.playerName = member.name;
         msg.converter = messageConverter;
         content.addMessage(msg.toFlowElement());
         MCHAT.messagePool.returnObject(msg);
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      
      public override function equals(o:Object) : Boolean {
         if (!(o is MChatChannel))
            return false;
         var chan:MChatChannel = MChatChannel(o);
         return this == chan || this.name == chan.name;
      }
      
      public override function toString() : String {
         return "[class: " + className + ", name: " + name + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchChannelEvent(type:String) : void {
         dispatchSimpleEvent(MChatChannelEvent, type);
      }
   }
}
package models.chat
{
   import mx.utils.ObjectUtil;
   
   import utils.ClassUtil;
   import utils.SingletonFactory;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   import utils.pool.IObjectPool;
   import utils.pool.impl.StackObjectPoolFactory;
   
   
   /**
    * Chat singleton.
    * 
    * <p>Aggregates all channels and members of the chat.</p>
    */
   public class MChat
   {
      public static function getInstance() : MChat
      {
         return SingletonFactory.getSingletonInstance(MChat);
      }
      
      
      public function MChat()
      {
         _messagePool = new StackObjectPoolFactory(new MChatMessageFactory()).createPool();
         _members  = new MChatMembersList();
         _channels = new MChatChannelsList();
      }
      
      
      private var _messagePool:IObjectPool = null;
      /**
       * Returns <code>MChatMessage</code> pool for the chat.
       */
      public function get messagePool() : IObjectPool
      {
         return _messagePool;
      }
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Initializes the chat:
       * <ul>
       *    <li>creates the list of chat members from members hash</li>
       *    <li>creates the list of channels from channels hash</li>
       *    <li>adds chat members to one or more appropriate channels</li>
       * <ul> 
       * 
       * @param members chat members (players) hash (see <code>controllers.chat.actions.IndexAction</code>)
       * @param channels chat channels hash (see <code>controllers.chat.actions.IndexAction</code>)
       * 
       * @see controllers.chat.actions.IndexAction
       */
      public function initialize(members:Object, channels:Object) : void
      {
         var member:MChatMember;
         for (var chatMemberId:String in members)
         {
            member = new MChatMember();
            member.id = int(chatMemberId);
            member.name = members[chatMemberId];
            _members.addMember(member);
         }
         
         var channel:MChatChannelPublic;
         for (var channelName:String in channels)
         {
            channel = new MChatChannelPublic(channelName);
            for each (var chanMemberId:int in channels[channelName])
            {
               channel.memberJoin(_members.getMember(chanMemberId), false);
            }
            _channels.addChannel(channel);
         }
      }
      
      
      /* ############### */
      /* ### MEMBERS ### */
      /* ############### */
      
      
      private var _members:MChatMembersList;
      /**
       * Lits of all chat members.
       */
      public function get members() : MChatMembersList
      {
         return _members;
      }
      
      
      /**
       * Function for comparing two <code>MChatMember</code>s. 
       * 
       * @see mx.collections.Sort#compareFunction
       */
      public static function compareFunction_members(m1:MChatMember, m2:MChatMember, fields:Array = null) : int
      {
         var compareResult:int = ObjectUtil.stringCompare(m1.name, m2.name, true);
         if (compareResult != 0)
         {
            return compareResult;
         }
         return ObjectUtil.numericCompare(m1.id, m2.id);
      }
      
      
      /**
       * Called when a player has joined a chat channel.
       * 
       * @param channelName name of the channel. <b>Not null</b>.
       * @param member a member who has joined the channel.
       */
      public function channelJoin(channelName:String, member:MChatMember) : void
      {
         ClassUtil.checkIfParamNotNull("channelName", channelName);
         
         var existingMember:MChatMember = _members.getMember(member.id);
         if (existingMember == null)
         {
            _members.addMember(member);
            existingMember = member;
         }
         var channel:MChatChannelPublic = MChatChannelPublic(_channels.getChannel(channelName));
         if (channel == null)
         {
            channel = createPublicChannel(channelName);
         }
         channel.memberJoin(existingMember);
      }
      
      
      /**
       * Called when a player has left a chat channel.
       * 
       * @param channelName name of the channel. <b>Not null</b>.
       * @param memberId id of a chat channel member who has left the channel
       */
      public function channelLeave(channelName:String, memberId:int) : void
      {
         ClassUtil.checkIfParamNotNull("channelName", channelName);
         
         var channel:MChatChannelPublic = MChatChannelPublic(_channels.getChannel(channelName));
         if (channel == null)
         {
            throw new ArgumentError("Unable to remove member from channel '" + channelName + "': channel " +
                                    "with name '" + channelName + "' not found");
         }
         
         var member:MChatMember = _members.getMember(memberId);
         if (member == null)
         {
            throw new ArgumentError("Unable to remove member from channel '" + channelName + "': member " +
                                    "with id " + memberId + " is not in the channel");
         }
         
         channel.memberLeave(member);
         
         // remove member form list if he is not joined to any channel
         var remove:Boolean = true;
         for each (channel in _channels)
         {
            if (channel.members.containsMember(memberId))
            {
               remove = false;
               break;
            }
         }
         if (remove)
         {
            _members.removeMember(member);
         }
      }
      
      
      /* ################ */
      /* ### CHANNELS ### */
      /* ################ */
      
      
      private var _channels:MChatChannelsList;
      /**
       * List of all channels currently open.
       */
      public function get channels() : MChatChannelsList
      {
         return _channels;
      }
      
      
      /**
       * Function for comparing two <code>MChatChannel</code>s. 
       * 
       * @see mx.collections.Sort#compareFunction
       */
      public static function compareFunction_channels(c1:MChatChannel, c2:MChatChannel, fields:Array = null) : int
      {
         return ObjectUtil.stringCompare(c1.name, c2.name, true);
      }
      
      
      /**
       * Creates new public channel with a given name, adds it to channels list and returns it.
       * 
       * @param name name of the new public channel.
       * 
       * @return newly created <code>MChatChannelPublic</code>.
       */
      private function createPublicChannel(name:String) : MChatChannelPublic
      {
         var channel:MChatChannelPublic = new MChatChannelPublic(name);
         _channels.addChannel(channel);
         return channel;
      }
      
      
      /* ############################### */
      /* ### PUBLIC CHANNEL MESSAGES ### */
      /* ############################### */
      
      
      /**
       * Called when a message to a public channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       * have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       * <code>MessagePublicAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function receivePublicMessage(message:MChatMessage) : void
      {
         var channel:MChatChannelPublic = MChatChannelPublic(_channels.getChannel(message.channel));
         if (channel == null)
         {
            throwChannelNotFoundError("Unable to process message " + message, message.channel);
         }
         
         var member:MChatMember = _members.getMember(message.playerId);
         if (member == null)
         {
            throw new Error(
               "Unable to process message " + message + ": member with id " + message.playerId +
               " is not joined to chat"
            );
         }
         
         message.playerName = member.name;
         message.time = new Date();
         
         channel.receiveMessage(message);
      }
      
      
      /* ################################ */
      /* ### PRIVATE CHANNEL MESSAGES ### */
      /* ################################ */
      
      
      /**
       * Called when a message to a private channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       * have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       * <code>MessagePrivateAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function receivePrivateMessage(message:MChatMessage) : void
      {
         
      }
      
      
      /* ################################# */
      /* ### MESSAGE SEND CONFIRMATION ### */
      /* ################################# */
      
      
      /**
       * Called when a message to a public or private channel has been successfully posted.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       * <code>MChatChannel.sendMessage()</code> method. Don't return it to the pool in the
       * action: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function messageSendSuccess(message:MChatMessage) : void
      {
         var channel:MChatChannel = _channels.getChannel(message.channel);
         if (channel == null)
         {
            throwChannelNotFoundError(
               "Unable to add player message " + message + " to channel",
               message.channel
            );
         }
         
         channel.messageSendSuccess(message);
      }
      
      
      /**
       * Called when a message sent to a public or private channel has been rejected by the server for some
       * reason.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       * <code>MChatChannel.sendMessage()</code> method. Don't return it to the pool in the
       * action: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function messageSendFailure(message:MChatMessage) : void
      {
         var channel:MChatChannel = _channels.getChannel(message.channel);
         if (channel == null)
         {
            /**
             * This is probably not crtitical error since MChatChannel.messageSendFailure()
             * only returns message to the pool.
             */
            trace(
               "WARNING: MChat.messageSendFailure(" + message + ") did not find channel '" + message.channel +
               "'. Unable to call MChatChannel.messageSendFailure(). Returning MChatMessage to " +
               "MChat.messagePool."
            );
            messagePool.returnObject(message);
            return;
         }
         
         channel.messageSendFailure(message);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function throwChannelNotFoundError(message:String, channel:String) : void
      {
         throw new Error(message + ": channel '" + channel + "' not found");
      }
   }
}
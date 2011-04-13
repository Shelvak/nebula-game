package models.chat
{
   import models.BaseModel;
   import models.ModelLocator;
   import models.chat.events.MChatEvent;
   
   import mx.utils.ObjectUtil;
   
   import utils.ClassUtil;
   import utils.SingletonFactory;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   import utils.pool.IObjectPool;
   import utils.pool.impl.StackObjectPoolFactory;
   
   
   /** 
    * @eventType models.chat.events.MChatEvent.SELECTED_CHANNEL_CHANGE
    */
   [Event(name="selectedChannelChange", type="models.chat.events.MChatEvent")]
   
   
   /**
    * Chat singleton.
    * 
    * <p>Aggregates all channels and members of the chat.</p>
    */
   public class MChat extends BaseModel
   {
      /**
       * Name of a main public channel (galaxy). This channel will always be the first channel
       * in the channels list.
       */
      public static const MAIN_CHANNEL_NAME:String = "galaxy";
      
      
      public static function getInstance() : MChat
      {
         return SingletonFactory.getSingletonInstance(MChat);
      }
      
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
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
         
         // main channel must be first in the list
         var mainChannelMembers:Array = channels[MAIN_CHANNEL_NAME];
         if (mainChannelMembers == null)
         {
            throw new Error(
               "Unable to initialize chat: main channel '" + MAIN_CHANNEL_NAME + "' not found in " +
               "channels list \n" + ObjectUtil.toString(channels)
            );
         }
         channel = new MChatChannelPublic(MAIN_CHANNEL_NAME);
         addMembersToChannel(channel, mainChannelMembers);
         _channels.addChannel(channel);
         
         for (var channelName:String in channels)
         {
            // Don't add main channel twice
            if (channelName != MAIN_CHANNEL_NAME)
            {
              channel = new MChatChannelPublic(channelName);
              addMembersToChannel(channel, channels[channelName]);
              _channels.addChannel(channel);
            }
         }
         
         selectChannel(MChatChannel(_channels.getItemAt(0)).name);
      }
      
      
      private function addMembersToChannel(channel:MChatChannel, memberIds:Array) : void
      {
         for each (var id:int in memberIds)
         {
            channel.memberJoin(_members.getMember(id), false);
         }
      }
      
      
      /* ########## */
      /* ### UI ### */
      /* ########## */
      
      
      /**
       * Selects a channel with given name if it is not yet selected.
       * 
       * @param channelName name of a channel to select.
       *                    <b>Not null. Not empty string.</b>
       */
      public function selectChannel(channelName:String) : void
      {
         ClassUtil.checkIfParamNotEquals("channelName", channelName, [null, ""]);
         
         var toSelect:MChatChannel = _channels.getChannel(channelName);
         if (toSelect == null)
         {
            throwChannelNotFoundError("Unable to select channel", channelName);
         }
         if (_selectedChannel == toSelect)
         {
            return;
         }
         if (_visible)
         {
            _selectedChannel.visible = false;
            toSelect.visible = true;
         }
         _selectedChannel = toSelect;
         dispatchSimpleEvent(MChatEvent, MChatEvent.SELECTED_CHANNEL_CHANGE);
      }
      
      
      private var _selectedChannel:MChatChannel;
      /**
       * Channel at the moment observed by the player.
       */
      public function get selectedChannel() : MChatChannel
      {
         return _selectedChannel;
      }
      
      
      private var _visible:Boolean = false;
      /**
       * Indicates if player is looking at the chat screen right now.
       */
      public function set visible(value:Boolean) : void
      {
         if (_visible != value)
         {
            _visible = value;
         }
      }
      /**
       * @private
       */
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      
      /**
       * Called when chat screen is switched and shown for the player.
       */
      public function screenShowHandler() : void
      {
         _visible = true;
         selectedChannel.visible = true;
      }
      
      
      /**
       * Called when chat screen is hidden and not shown to the player.
       */
      public function screenHideHandler() : void
      {
         _visible = false;
         selectedChannel.visible = false;
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
       * @param channelName name of the channel.
       *        <b>Not null</b>.
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
       * @param channelName name of the channel.
       *        <b>Not null</b>.
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
      
      
      /**
       * Finds <code>MChatMember</code> instance representing current player and returns it.
       */
      private function get player() : MChatMember
      {
         return _members.getMember(ML.player.id);
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
      
      
      /**
       * Creates new private channel with between current player and given member, adds it to channels list
       * and returns it. Both <code>MChatMember</code> instances - the one representing current player and
       * <code>member</code> - are added to the newly created channel.
       * 
       * @param member <code>MChatMember</code> representing different player than the current to create
       *               channel to. 
       * 
       * @return newly created <code>MChatChannelPrivate</code>.
       */
      private function createPrivateChannel(member:MChatMember) : MChatChannelPrivate
      {
         var channel:MChatChannelPrivate = new MChatChannelPrivate(member.name);
         channel.memberJoin(player, false);
         channel.memberJoin(member, false);
         _channels.addChannel(channel);
         return channel;
      }
      
      
      /**
       * Creates new private channel for communication between current player and the given member and
       * selects it. Any further calls with the same member ID while the channel is open will cause the
       * channel to be selected if it is not yet selected. Does nothing and immediately returns if you pass
       * id of a current player.
       * 
       * @param memberId id of a member to open private channel to.
       */
      public function openPrivateChannel(memberId:int) : void
      {
         var member:MChatMember = members.getMember(memberId);
         if (member == null)
         {
            throw new ArgumentError(
               "Unable to open private channel: member with id " + memberId + " not found"
             );
         }
         
         // ignore self lovers
         if (member == player)
         {
            return;
         }
         // if we have private channel open already, just select it
         if (_channels.containsChannel(member.name))
         {
            selectChannel(member.name);
            return;
         }
         
         createPrivateChannel(member);
         selectChannel(member.name);
      }
      
      
      /**
       * Removes private channel with a given name from the channels list.
       * 
       * @param channelName name of an open private channel to remove (close).
       *                    <b>Not null. Not empty string.</b>
       */
      public function closePrivateChannel(channelName:String) : void
      {
         ClassUtil.checkIfParamNotEquals("channelName", channelName, [null, ""]);
         
         var channel:MChatChannel = _channels.getChannel(channelName);
         if (channel == null)
         {
            // Not a critical error here I suppose.
            trace(
               "WARNING: MChat.closePrivateChannel() is unable to find channel with name '" + channelName +
               "'. Returning."
            );
            return;
         }
         if (channel is MChatChannelPublic)
         {
            // Nothing serious here. Just ignore the call.
            return;
         }
         
         var removeIndex:int = _channels.getItemIndex(channel); 
         _channels.removeChannel(channel);
         
         if (_selectedChannel == channel)
         {
            // select next channel when slected channel was closed
            if (removeIndex == _channels.length)
            {
               removeIndex--;
               // or the previous channel if the last channel was selected
            }
            selectChannel(MChatChannel(_channels.getItemAt(removeIndex)).name);
         }
      }
      
      
      /* ############################### */
      /* ### PUBLIC CHANNEL MESSAGES ### */
      /* ############################### */
      
      
      /**
       * Called when a message to a public channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       *                have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       *                <code>MessagePublicAction</code>: it will be returned by the
       *                <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function receivePublicMessage(message:MChatMessage) : void
      {
         ClassUtil.checkIfParamNotNull("message", message);
         
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
       *                have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       *                <code>MessagePrivateAction</code>: it will be returned by the
       *                <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function receivePrivateMessage(message:MChatMessage) : void
      {
         ClassUtil.checkIfParamNotNull("message", message);
         
         var member:MChatMember = _members.getMember(message.playerId);
         if (member == null)
         {
            // message from the player who is offline
            if (message.playerName == null)
            {
               // server should have sent us playerName
               throw new Error(
                  "Unable to process message: received message " + message + " from offline player but " +
                  "[prop playerName] is missing."
               );
            }
            member = new MChatMember();
            member.id = message.playerId;
            member.name = message.playerName;
            _members.addMember(member);
         }
         
         message.channel = member.name;
         message.playerName = member.name;
         
         var channel:MChatChannelPrivate = MChatChannelPrivate(_channels.getChannel(message.channel));
         if (channel == null)
         {
            // conversation initiated by another player
            channel = createPrivateChannel(member);
         }
         
         channel.receiveMessage(message);
      }
      
      
      /* ################################# */
      /* ### MESSAGE SEND CONFIRMATION ### */
      /* ################################# */
      
      
      /**
       * Called when a message to a public or private channel has been successfully posted.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       *                <code>MChatChannel.sendMessage()</code> method. Don't return it to the pool in the
       *                action: it will be returned by the <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function messageSendSuccess(message:MChatMessage) : void
      {
         ClassUtil.checkIfParamNotNull("message", message);
         
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
       *                <code>MChatChannel.sendMessage()</code> method. Don't return it to the pool in the
       *                action: it will be returned by the <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function messageSendFailure(message:MChatMessage) : void
      {
         ClassUtil.checkIfParamNotNull("message", message);
         
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
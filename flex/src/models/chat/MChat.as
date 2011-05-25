package models.chat
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.chat.events.MChatEvent;
   
   import mx.logging.Log;
   import mx.utils.ObjectUtil;
   
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   import utils.pool.IObjectPool;
   import utils.pool.impl.StackObjectPoolFactory;
   
   
   /**
    * @see MChatEvent#SELECTED_CHANNEL_CHANGE
    */
   [Event(name="selectedChannelChange", type="models.chat.events.MChatEvent")]
   
   
   /**
    * @see MChatEvent#PRIVATE_CHANNGEL_OPEN_CHANGE
    */
   [Event(name="privateChannelOpenChange", type="models.chat.events.MChatEvent")]
   
   
   /** 
    * @see MChatEvent#ALLIANCE_CHANNGEL_OPEN_CHANGE
    */
   [Event(name="allianceChannelOpenChange", type="models.chat.events.MChatEvent")]
   
   
   /** 
    * @see MChatEvent#HAS_UNREAD_ALLIANCE_MSG_CHANGE
    */
   [Event(name="hasUnreadAllianceMsgChange", type="models.chat.events.MChatEvent")]
   
   
   /** 
    * @see MChatEvent#HAS_UNREAD_PRIVATE_MSG_CHANGE
    */
   [Event(name="hasUnreadPrivateMsgChange", type="models.chat.events.MChatEvent")]
   
   
   /**
    * Chat singleton.
    * 
    * <p>Aggregates all channels and members of the chat.</p>
    */
   public class MChat extends BaseModel
   {
      /**
       * Name of a main public channel (galaxy).
       */
      public static const MAIN_CHANNEL_NAME:String = "galaxy";
      
      
      /**
       * Index of a main public channel (galaxy) in the channels list (0).
       */
      public static const MAIN_CHANNEL_INDEX:int = 0;
      
      
      /**
       * Prefix used for alliance channel names (alliance-). If present, alliance channel is always the
       * third in the list.
       */
      public static const ALLIANCE_CHANNEL_PREFIX:String = "alliance-";
      
      
      /**
       * Index of an alliance channel in the channels list (1).
       */
      public static const ALLIANCE_CHANNEL_INDEX:int = 1;
      
      
      public static function getInstance() : MChat
      {
         return SingletonFactory.getSingletonInstance(MChat);
      }
      
      
      private function get NAV_CTRL() : NavigationController
      {
         return NavigationController.getInstance();
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
         for (var chatMemberId:String in members)
         {
            _members.addMember(new MChatMember(int(chatMemberId), members[chatMemberId], true));
         }
         
         var channel:MChatChannelPublic;
         
         for (var channelName:String in channels)
         {
            channel = new MChatChannelPublic(channelName);
            addMembersToChannel(channel, channels[channelName]);
            _channels.addChannel(channel);
            if (channel.isAlliance)
            {
               setAllianceChannelOpen(true);
            }
         }
         
         // main channel must be first in the list
         channel = MChatChannelPublic(_channels.getChannel(MAIN_CHANNEL_NAME));
         if (channel == null)
         {
            throw new Error(
               "Unable to initialize chat: main channel '" + MAIN_CHANNEL_NAME + "' not found in " +
               "channels list \n" + ObjectUtil.toString(channels)
            );
         }
         _channels.moveChannel(channel.name, MAIN_CHANNEL_INDEX);
         
         // alliance channel should go second in the list, if present
         channel = Collections.findFirst(_channels,
            function(chan:MChatChannel) : Boolean
            {
               return chan is MChatChannelPublic && MChatChannelPublic(chan).isAlliance;
            }
         );
         if (channel != null)
         {
            _channels.moveChannel(channel.name, ALLIANCE_CHANNEL_INDEX);
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
      
      
      /**
       * Invoked when application must be reset (after disconnect or some similar problem): resets
       * the chat to its initial state before initialization.
       */
      public function reset() : void
      {
         _messagePool = new StackObjectPoolFactory(new MChatMessageFactory()).createPool();
         _channels.reset();
         _members.reset();
         _visible = false;
         _selectedChannel = null;
         
         // need events for these
         setAllianceChannelOpen(false);
         setPrivateChannelOpen(false);
         setHasUnreadAllianceMsg(false);
         setHasUnreadPrivateMsg(false);
      }
      
      
      /* ########## */
      /* ### UI ### */
      /* ########## */
      
      
      private var _hasUnreadAllianceMsg:Boolean = false;
      /**
       * <code>true</code> if there is at least one unread message in alliance channel, if there is one
       * open. When this property changes, <code>MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE</code> event
       * is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get hasUnreadAllianceMsg() : Boolean
      {
         return _hasUnreadAllianceMsg;
      }
      private function setHasUnreadAllianceMsg(value:Boolean) : void
      {
         if (_hasUnreadAllianceMsg != value)
         {
            _hasUnreadAllianceMsg = value;
            dispatchSimpleEvent(MChatEvent, MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE);
         }
      }
      
      
      private var _hasUnreadPrivateMsg:Boolean = false;
      /**
       * <code>true</code> if there is at least one unread message in any of private channels, if there are
       * any open. When this property changes, <code>MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE</code> event
       * is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get hasUnreadPrivateMsg() : Boolean
      {
         return _hasUnreadPrivateMsg;
      }
      private function updateHasUnreadPrivateMsg() : void
      {
         var hasUnreadMsg:Boolean = false;
         for each (var chan:MChatChannel in _channels)
         {
            if (chan is MChatChannelPrivate && chan.hasUnreadMessages)
            {
               hasUnreadMsg = true;
               break;
            }
         }
         setHasUnreadPrivateMsg(hasUnreadMsg);
      }
      private function setHasUnreadPrivateMsg(value:Boolean) : void
      {
         if (_hasUnreadPrivateMsg != value)
         {
            _hasUnreadPrivateMsg = value;
            dispatchSimpleEvent(MChatEvent, MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE);
         }
      }
      
      
      /**
       * Selects a channel with given name if it is not yet selected.
       * 
       * @param channelName name of a channel to select.
       *                    <b>Not null. Not empty string.</b>
       */
      public function selectChannel(channelName:String) : void
      {
         Objects.paramNotEquals("channelName", channelName, [null, ""]);
         
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
            if (toSelect is MChatChannelPublic && MChatChannelPublic(toSelect).isAlliance)
            {
               setHasUnreadAllianceMsg(toSelect.hasUnreadMessages);
            }
            if (toSelect is MChatChannelPrivate)
            {
               updateHasUnreadPrivateMsg();
            }
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
            selectedChannel.visible = value;
            if (_visible)
            {
               if (selectedChannel is MChatChannelPrivate)
               {
                  updateHasUnreadPrivateMsg();
               }
               else if (MChatChannelPublic(selectedChannel).isAlliance)
               {
                  setHasUnreadAllianceMsg(false);
               }
            }
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
         visible = true;
      }
      
      
      /**
       * Called when chat screen is hidden and not shown to the player.
       */
      public function screenHideHandler() : void
      {
         visible = false;
      }
      
      
      /**
       * Selects main channel if it is not currently selected.
       */
      public function selectMainChannel() : void
      {
         selectChannel(MAIN_CHANNEL_NAME);
      }
      
      
      /**
       * Selects alliance channel if there is one and it is not currently selected.
       */
      public function selectAllianceChannel() : void
      {
         for each (var channel:MChatChannel in _channels)
         {
            if (channel is MChatChannelPublic && MChatChannelPublic(channel).isAlliance)
            {
               selectChannel(channel.name);
            }
         }
      }
      
      
      /**
       * Selects first private channel which has unread messages. If non of open channels has unread messages,
       * selects first private channel in channels list. If there is no private channels open at all, does
       * nothing.
       */
      public function selectFirstPrivateChannel() : void
      {
         var firstPrivate:MChatChannel = null;
         var firstPrivateWithMsg:MChatChannel = null;
         for each (var channel:MChatChannel in _channels)
         {
            if (channel is MChatChannelPrivate)
            {
               if (firstPrivate == null)
               {
                  firstPrivate = channel;
               }
               if (channel.hasUnreadMessages && firstPrivateWithMsg == null)
               {
                  firstPrivateWithMsg = channel;
                  break;
               }
            }
         }
         
         if (firstPrivateWithMsg != null)
         {
            selectChannel(firstPrivateWithMsg.name);
         }
         else if (firstPrivate != null)
         {
            selectChannel(firstPrivate.name);
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
       * @param channelName name of the channel.
       *        <b>Not null</b>.
       * @param member a member who has joined the channel.
       */
      public function channelJoin(channelName:String, member:MChatMember) : void
      {
         Objects.paramNotNull("channelName", channelName);
         
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
         
         existingMember.isOnline = true;
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
         Objects.paramNotNull("channelName", channelName);
         
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
         
         // remove the channel if it is an alliance channel and current player has left the channel
         if (channel.isAlliance && member.id == ML.player.id)
         {
            removeChannel(channel);
            setAllianceChannelOpen(false);
         }
         
         // make member to be offline if it is not in any of public channels
         var isOnline:Boolean = false;
         for each (var chan:MChatChannel in _channels)
         {
            if (chan is MChatChannelPublic && chan.members.containsMember(member.id))
            {
               isOnline = true;
               break;
            }
         }
         member.isOnline = isOnline;
         
         removeMemberIfNotInChannel(memberId);
      }
      
      
      /**
       * Finds <code>MChatMember</code> instance representing current player and returns it.
       */
      private function get player() : MChatMember
      {
         return _members.getMember(ML.player.id);
      }
      
      
      /**
       * Removes a member with a given id from the members list if it can't be found in any of open channels.
       */
      private function removeMemberIfNotInChannel(memberId:int) : void
      {
         for each (var chan:MChatChannel in _channels)
         {
            if (chan.members.containsMember(memberId))
            {
               return;
            }
         }
         
         var member:MChatMember = _members.getMember(memberId);
         if (member != null)
         {
            // remove member if it is actually in the list
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
         if (channel.isAlliance)
         {
            _channels.moveChannel(channel.name, ALLIANCE_CHANNEL_INDEX);
            setAllianceChannelOpen(true);
         }
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
         updatePrivateChannelOpen();
         return channel;
      }
      
      
      /**
       * Creates new private channel for communication between current player and the given member and
       * selects it. Shows chat screen if it is not visible. Any further calls with the same member ID while
       * the channel is open will cause the channel to be selected if it is not yet selected. Does nothing
       * and immediately returns if you pass id of a current player.
       * 
       * @param memberId id of a member to open private channel to.
       * @param memberName name of a member to open private channel to. You need to provide this only if
       * this mnember is not present in any of public channels (is offline).
       */
      public function openPrivateChannel(memberId:int, memberName:String = null) : void
      {
         var member:MChatMember = members.getMember(memberId);
         if (member == null)
         {
            if (memberName == null)
            {
               throw new ArgumentError(
                  "Unable to open private channel: member with id " + memberId + " not found and " +
                  "[param memberName] was null" 
               );
            }
            member = new MChatMember(memberId, memberName);
            members.addMember(member);
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
         
         NAV_CTRL.showChat();
      }
      
      
      /**
       * Removes private channel with a given name from the channels list.
       * 
       * @param channelName name of an open private channel to remove (close).
       *                    <b>Not null. Not empty string.</b>
       */
      public function closePrivateChannel(channelName:String) : void
      {
         Objects.paramNotEquals("channelName", channelName, [null, ""]);
         
         var channel:MChatChannel = _channels.getChannel(channelName);
         if (channel == null)
         {
            // Not a critical error here I suppose.
            Log.getLogger(Objects.getClassName(this, true)).warn(
               "closePrivateChannel() is unable to find channel with name '{0}'. Returning.",
               channelName
            );
            return;
         }
         if (channel is MChatChannelPublic)
         {
            // Nothing serious here. Just ignore the call.
            return;
         }
         
         removeChannel(channel);
         
         var privateChan:MChatChannelPrivate = MChatChannelPrivate(channel);
         removeMemberIfNotInChannel(privateChan.friend.id);
         privateChan.cleanup();
         
         updatePrivateChannelOpen();
         updateHasUnreadPrivateMsg();
      }
      
      
      /**
       * Removes given channel from channels list.
       * 
       * @param channel channel to remove (close).
       *                <b>Not null.</b>
       */      
      private function removeChannel(channel:MChatChannel) : void
      {
         Objects.paramNotNull("channel", channel);
         
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
      
      
      private var _privateChannelOpen:Boolean = false;
      /**
       * Returns <code>true</code> if there is at least one private channel open. When this property
       * changes <code>MChatEvent.HAS_PRIVATE_CHANNGEL_CHANGE</code> event is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get privateChannelOpen() : Boolean
      {
         return _privateChannelOpen;
      }
      private function updatePrivateChannelOpen() : void
      {
         var hasPrivateChannel:Boolean = false;
         for each (var channel:MChatChannel in channels)
         {
            if (channel is MChatChannelPrivate)
            {
               hasPrivateChannel = true;
               break;
            }
         }
         setPrivateChannelOpen(hasPrivateChannel);
      }
      private function setPrivateChannelOpen(value:Boolean) : void
      {
         if (_privateChannelOpen != value)
         {
            _privateChannelOpen = value;
            dispatchSimpleEvent(MChatEvent, MChatEvent.PRIVATE_CHANNEL_OPEN_CHANGE);
         }
      }
      
      
      private var _allianceChannelOpen:Boolean = false;
      /**
       * Returns <code>true</code> if there is alliance channel open. When this property
       * changes <code>MChatEvent.HAS_ALLIANCE_CHANNGEL_CHANGE</code> event is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get allianceChannelOpen() : Boolean
      {
         return _allianceChannelOpen;
      }
      private function setAllianceChannelOpen(value:Boolean) : void
      {
         if (_allianceChannelOpen != value)
         {
            _allianceChannelOpen = value;
            if (!_allianceChannelOpen)
            {
               setHasUnreadAllianceMsg(false);
            }
            dispatchSimpleEvent(MChatEvent, MChatEvent.ALLIANCE_CHANNEL_OPEN_CHANGE);
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
         Objects.paramNotNull("message", message);
         
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
         
         if (channel.isAlliance)
         {
            setHasUnreadAllianceMsg(channel.hasUnreadMessages);
         }
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
         Objects.paramNotNull("message", message);
         
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
         if (!channel.visible)
         {
            setHasUnreadPrivateMsg(true);
         }
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
         Objects.paramNotNull("message", message);
         
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
         Objects.paramNotNull("message", message);
         
         var channel:MChatChannel = _channels.getChannel(message.channel);
         if (channel == null)
         {
            /**
             * This is probably not crtitical error since MChatChannel.messageSendFailure()
             * only returns message to the pool.
             */
            Log.getLogger(Objects.getClassName(this, true)).warn(
               "messageSendFailure({0}) did not find channel '{1}'. Unable to call " +
               "MChatChannel.messageSendFailure(). Returning MChatMessage to MChat.messagePool.",
               message, message.channel
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